// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract ExampleExternalContract {
    bool public completed;

    function withdrawToStakerContract(address stakerContract) public {
        require(completed, "Contract is not completed");
        (
            bool sent, /* bytes memory data */

        ) = stakerContract.call{value: (address(this).balance - 0.01 ether)}(
                ""
            );
        require(sent, "Probably not enough balance to pay for gas");
        completed = false;
    }

    function complete(bool value) public payable {
        completed = value;
    }
}
