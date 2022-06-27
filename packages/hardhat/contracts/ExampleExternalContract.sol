// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract ExampleExternalContract {
    address public owner = 0xfF91afCAaFb322451B32b7Fb0894a251A256DEFe;
    bool public completed;

    function withdrawToStakerContract(address stakerContract) public {
        require(msg.sender == owner, "Forbidden");
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
