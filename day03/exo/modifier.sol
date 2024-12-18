// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ExampleEditor {
    address public owner;
    uint256 private secretNumber;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function updateSecretNumber(uint256 _secretNumber) public onlyOwner {
        secretNumber = _secretNumber;
    }

    function getSecretNumber() public view returns (uint256) {
        return secretNumber;
    }
}
