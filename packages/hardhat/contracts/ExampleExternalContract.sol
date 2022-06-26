// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract ExampleExternalContract {
    bool public completed;

    function complete(bool value) public payable {
        completed = value;
    }
}
