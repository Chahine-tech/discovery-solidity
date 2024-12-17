// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PersonInfo {
    struct Person {
        string name;
        uint age;
    }

    Person public person;
    uint[] public timestamp;
    Person[] public people;
    uint public personCount;

    constructor(string memory _name, uint _age) {
        person = Person(_name, _age);
        addPerson(_name, _age);
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

    function cal(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

    function addPerson(string memory _name, uint _age) public {
        people.push(Person(_name, _age));
        personCount++;
    }
    
    function removeLastPerson() public {
        require(personCount > 0, "No person to remove");
        people.pop();
        personCount--;
    }
    
    function countPeople() public view returns (uint) {
        return personCount;
    }
}