// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ProjectManagement.sol";

contract TaskManagement is ProjectManagement {

    struct Task {
        uint256 id;
        string description;
        bool completed;
    }

    event TaskAdded(uint256 projectId, uint256 taskId, string description);
    event TaskCompleted(uint256 projectId, uint256 taskId);
    event TaskReset(uint256 projectId, uint256 taskId);
    event TaskDeleted(uint256 projectId, uint256 taskId);
    event AllTasksCompleted(uint256 projectId);

    mapping(uint256 => mapping(uint256 => Task)) public projectTasks;

    function addTask(uint256 _projectId, string memory _description) public onlyCollaboratorOrOwner {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        uint256 taskId = project.numberOfTasks++;
        projectTasks[_projectId][taskId] = Task(taskId, _description, false);
        emit TaskAdded(_projectId, taskId, _description);
    }

    function completeTask(uint256 _projectId, uint256 _taskId) public onlyCollaboratorOrOwner {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        require(_taskId < project.numberOfTasks, "Task does not exist");
        Task storage task = projectTasks[_projectId][_taskId];
        require(!task.completed, "Task is already completed");
        
        task.completed = true;
        emit TaskCompleted(_projectId, _taskId);
    }

    function resetTask(uint256 _projectId, uint256 _taskId) public onlyCollaboratorOrOwner {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        require(_taskId < project.numberOfTasks, "Task does not exist");
        Task storage task = projectTasks[_projectId][_taskId];
        require(task.completed, "Task is not completed");

        task.completed = false;
        emit TaskReset(_projectId, _taskId);
    }

    function deleteTask(uint256 _projectId, uint256 _taskId) public onlyOwner {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        require(_taskId < project.numberOfTasks, "Task does not exist");

        delete projectTasks[_projectId][_taskId];

        project.numberOfTasks--;
        emit TaskDeleted(_projectId, _taskId);
    }

    function completeAllTasks(uint256 _projectId) public onlyOwner {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        for (uint256 i = 0; i < project.numberOfTasks; i++) {
            projectTasks[_projectId][i].completed = true;
        }
        emit AllTasksCompleted(_projectId);
    }

    function listAllProjectDescriptions(uint256 _projectId) public view returns (string[] memory) {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        string[] memory descriptions = new string[](project.numberOfTasks);
        for (uint256 i = 0; i < project.numberOfTasks; i++) {
            descriptions[i] = projectTasks[_projectId][i].description;
        }
        return descriptions;
    }

    function getTotalTasks(uint256 _projectId) public view returns (uint256) {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        return project.numberOfTasks;
    }

    function getTask(uint256 _projectId, uint256 _taskId)
        public
        view
        returns (uint256, string memory, bool)
    {
        require(_projectId < projectCount, "Project does not exist");
        require(_taskId < projects[_projectId].numberOfTasks, "Task does not exist");

        Task storage task = projectTasks[_projectId][_taskId];
        return (task.id, task.description, task.completed);
    }
}