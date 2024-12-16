// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;



contract PersonInfo {
    struct Person {
        string name;
        uint age;
    }

    Person public person;
    uint[] public timestamp;

    constructor(string memory _name, uint _age) {
        person = Person(_name, _age);
    }

    function updatePerson(string memory _name, uint _age) public {
        person.name = _name;
        person.age = _age;
        timestamp.push(block.timestamp);
    } 

    function get() public view returns (string memory, uint ) {
        return (person.name, person.age);
    }

    function getTimestamp() public view returns(uint[] memory) {
        return timestamp;
    }
    
}