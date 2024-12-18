// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ProjectManagement {
    struct Project {
        uint256 id;
        string name;
        uint256 numberOfTasks;
    }

    struct CollaboratorInfo {
        string name;
        string email;
        bool pending;
    }

    address public owner;
    uint256 public projectCount;
    mapping(uint256 => Project) public projects;
    mapping(address => bool) internal collaborators;
    mapping(address => CollaboratorInfo) internal collaboratorInfo;
    address[] public pendingRequests;

    event ProjectAdded(uint256 id, string name);
    event ProjectOwnerChanged(address newOwner);
    event CollaboratorAdded(address collaborator);
    event CollaboratorRemoved(address collaborator);
    event CollaborationRequested(address requester, string name, string email);
    event CollaborationAccepted(address collaborator);
    event CollaborationRejected(address requester);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier onlyCollaborator() {
        require(
            collaborators[msg.sender] == true,
            "Caller is not a collaborator"
        );
        _;
    }

    modifier onlyCollaboratorOrOwner() {
        require(
            collaborators[msg.sender] || msg.sender == owner,
            "Caller is not a collaborator or the owner"
        );
        _;
    }

    function addCollaborator(
        address _collaborator,
        string memory _name,
        string memory _email
    ) public onlyOwner {
        require(_collaborator != address(0), "Invalid address");
        collaborators[_collaborator] = true;
        collaboratorInfo[_collaborator] = CollaboratorInfo(
            _name,
            _email,
            false
        );
        emit CollaboratorAdded(_collaborator);
    }

    function removeCollaborator(address _collaborator) public onlyOwner {
        require(collaborators[_collaborator], "Address is not a collaborator");
        collaborators[_collaborator] = false;
        delete collaboratorInfo[_collaborator];
        emit CollaboratorRemoved(_collaborator);
    }

    function getCollaboratorInfo(address _collaborator)
        public
        view
        returns (
            string memory,
            string memory,
            bool
        )
    {
        CollaboratorInfo storage info = collaboratorInfo[_collaborator];
        return (info.name, info.email, info.pending);
    }

    function addProject(string memory _name) public onlyOwner {
        uint256 projectId = projectCount++;
        projects[projectId] = Project(projectId, _name, 0);
        emit ProjectAdded(projectId, _name);
    }

    function changeProjectOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        owner = newOwner;
        emit ProjectOwnerChanged(newOwner);
    }

    function getProject(uint256 _projectId)
        public
        view
        returns (
            uint256,
            string memory,
            uint256
        )
    {
        require(_projectId < projectCount, "Project does not exist");

        Project storage project = projects[_projectId];
        return (project.id, project.name, project.numberOfTasks);
    }

    function requestCollaboration(string memory _name, string memory _email)
        public
    {
        require(!collaborators[msg.sender], "Already a collaborator");
        require(
            !collaboratorInfo[msg.sender].pending,
            "Request already pending"
        );

        collaboratorInfo[msg.sender] = CollaboratorInfo(_name, _email, true);
        pendingRequests.push(msg.sender);

        emit CollaborationRequested(msg.sender, _name, _email);
    }

    function acceptCollaboration(address _requester) public onlyOwner {
        require(
            collaboratorInfo[_requester].pending,
            "No pending request from this address"
        );

        collaborators[_requester] = true;
        collaboratorInfo[_requester].pending = false;

        // Remove the accepted request from the pendingRequests array
        for (uint256 i = 0; i < pendingRequests.length; i++) {
            if (pendingRequests[i] == _requester) {
                pendingRequests[i] = pendingRequests[
                    pendingRequests.length - 1
                ];
                pendingRequests.pop();
                break;
            }
        }

        emit CollaborationAccepted(_requester);
    }

    function rejectCollaboration(address _requester) public onlyOwner {
        require(
            collaboratorInfo[_requester].pending,
            "No pending request from this address"
        );

        collaboratorInfo[_requester].pending = false;

        // Remove the rejected request from the pendingRequests array
        for (uint256 i = 0; i < pendingRequests.length; i++) {
            if (pendingRequests[i] == _requester) {
                pendingRequests[i] = pendingRequests[
                    pendingRequests.length - 1
                ];
                pendingRequests.pop();
                break;
            }
        }

        emit CollaborationRejected(_requester);
    }

    function getPendingRequests() public view returns (address[] memory) {
        return pendingRequests;
    }
}