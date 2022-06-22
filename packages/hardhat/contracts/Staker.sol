// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositTimestamps;

    uint256 public constant rewardRatePerBlock = 0.1 ether;
    uint256 public withdrawalDeadline = block.timestamp + 120 seconds;
    uint256 public claimDeadline = block.timestamp + 240 seconds;
    uint256 public currentBlock = 0;

    event Stake(address indexed sender, uint256 amount);
    event Received(address, uint256);
    event Execute(address indexed sender, uint256 amount);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    function withdrawalTimeLeft()
        public
        view
        returns (uint256 _withdrawalTimeLeft)
    {
        return
            block.timestamp > withdrawalDeadline
                ? 0
                : withdrawalDeadline - block.timestamp;
    }

    function claimPeriodLeft() public view returns (uint256 _claimPeriodLeft) {
        return
            block.timestamp > claimDeadline
                ? 0
                : claimDeadline - block.timestamp;
    }

    function stake()
        public
        payable
        withdrawalDeadlineReached(false)
        claimDeadlineReached(false)
    {
        balances[msg.sender] = balances[msg.sender] + msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
        emit Stake(msg.sender, msg.value);
    }

    function withdraw()
        public
        withdrawalDeadlineReached(true)
        claimDeadlineReached(false)
        notCompleted
    {
        require(balances[msg.sender] > 0, "You have no balance to withdraw");
        uint256 balance = balances[msg.sender];
        uint256 rewards = balance +
            ((block.timestamp - depositTimestamps[msg.sender]) *
                rewardRatePerBlock);
        balances[msg.sender] = 0;

        (bool sent, bytes memory data) = msg.sender.call{value: rewards}("");
        require(sent, "Withdrawal failed, try again");
    }

    function execute() public claimDeadlineReached(true) notCompleted {
        uint256 contractBalance = address(this).balance;
        exampleExternalContract.complete{value: contractBalance}();
    }

    // Modifiers
    modifier withdrawalDeadlineReached(bool requireReached) {
        uint256 timeRemaining = withdrawalTimeLeft();
        requireReached
            ? require(
                timeRemaining == 0,
                "Withdrawal period is not reached yet"
            )
            : require(timeRemaining > 0, "Claim deadline has been reached");
        _;
    }

    modifier claimDeadlineReached(bool requireReached) {
        uint256 timeRemaining = claimPeriodLeft();
        requireReached
            ? require(timeRemaining == 0, "Claim deadline is not reached yet")
            : require(timeRemaining > 0, "Claim deadline has been reached");
        _;
    }

    modifier notCompleted() {
        require(
            !exampleExternalContract.completed(),
            "Stake already completed"
        );
        _;
    }
}
