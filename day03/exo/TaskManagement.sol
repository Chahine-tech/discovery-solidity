// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TaskManagement {
    struct Task {
        uint256 id;
        string description;
        bool completed;
    }

    address public owner;
    uint256 private numberOfTasks;
    mapping(uint256 => Task) private tasks;

    event TaskAdded(uint256 id, string description);
    event TaskCompleted(uint256 id);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function addTask(string memory _description) public onlyOwner {
        uint256 taskId = numberOfTasks++;
        tasks[taskId] = Task(taskId, _description, false);
        emit TaskAdded(taskId, _description);
    }

    function completeTask(uint256 _id) public onlyOwner {
        require(_id < numberOfTasks, "Task does not exist");
        Task storage task = tasks[_id];
        require(!task.completed, "Task is already completed");
        task.completed = true;
        emit TaskCompleted(_id);
    }

    function getTotalTasks() public view returns (uint256) {
        return numberOfTasks;
    }

    function getTask(uint256 _id)
        public
        view
        returns (
            uint256,
            string memory,
            bool
        )
    {
        require(_id < numberOfTasks, "Task does not exist");
        Task storage task = tasks[_id];
        return (task.id, task.description, task.completed);
    }
}