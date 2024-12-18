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
    event TaskReset(uint256 id);
    event TaskDeleted(uint256 id);
    event ProjectOwnerChanged(address newOwner);
    event AllTasksCompleted();

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
        require(!tasks[_id].completed, "Task is already completed");

        tasks[_id].completed = true;
        emit TaskCompleted(_id);
    }

    function resetTask(uint256 _id) public onlyOwner {
        require(_id < numberOfTasks, "Task does not exist");
        require(tasks[_id].completed, "Task is not completed");

        tasks[_id].completed = false;
        emit TaskReset(_id);
    }

    function deleteTask(uint256 _id) public onlyOwner {
        require(_id < numberOfTasks, "Task does not exist");

        tasks[_id] = tasks[numberOfTasks - 1];
        delete tasks[numberOfTasks - 1];
        numberOfTasks--;

        emit TaskDeleted(_id);
    }

    function changeProjectOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        owner = newOwner;
        emit ProjectOwnerChanged(newOwner);
    }

    function completeAllTasks() public onlyOwner {
        for (uint256 i = 0; i < numberOfTasks; i++) {
            tasks[i].completed = true;
        }
        emit AllTasksCompleted();
    }

    function listAllDescriptions() public view returns (string[] memory) {
        string[] memory descriptions = new string[](numberOfTasks);
        for (uint256 i = 0; i < numberOfTasks; i++) {
            descriptions[i] = tasks[i].description;
        }
        return descriptions;
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
