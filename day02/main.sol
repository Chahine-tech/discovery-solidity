// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PersonInfo {
    struct Person {
        string name;
        uint256 age;
    }

    Person public person;
    uint256[] public timestamp;
    Person[] public people;
    uint256 public personCount;

    constructor(string memory _name, uint256 _age) {
        person = Person(_name, _age);
        addPerson(_name, _age);
    }

    function updatePerson(string memory _name, uint256 _age) public {
        person.name = _name;
        person.age = _age;
        timestamp.push(block.timestamp);
    }

    function get() public view returns (string memory, uint256) {
        return (person.name, person.age);
    }

    function getOne(uint256 personIndex) public view returns (Person memory) {
        require(personIndex < personCount, "Index out of bounds");
        return people[personIndex];
    }

    function getAll() public view returns (Person[] memory) {
        return people;
    }

    function getTimestamp() public view returns (uint256[] memory) {
        return timestamp;
    }

    function cal(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function addPerson(string memory _name, uint256 _age) public {
        people.push(Person(_name, _age));
        personCount++;
    }

    function removeLastPerson() public {
        require(personCount > 0, "No person to remove");
        people.pop();
        personCount--;
    }

    function countPeople() public view returns (uint256) {
        return personCount;
    }
}
