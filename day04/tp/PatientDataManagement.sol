// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract PatientContract {
    // Structure to define a Patient
    struct Patient {
        uint256 id;
        address patientAddress;
        string cin;
        string firstName;
        string lastName;
        uint256 age;
        string gender;
        string region;
        string testResult;
    }

    // Roles' addresses
    address public responsibleDoctor;
    address public regionalDirector;
    address public mediaNetwork;

    // Array to store patients
    Patient[] public patients;

    // Mappings for statistics
    mapping(string => uint256) public patientsByRegion;
    mapping(string => mapping(string => uint256))
        public patientsByRegionAndGender;
    mapping(string => mapping(uint8 => uint256))
        public patientsByRegionAndAgeGroup;

    // Mapping to manage patient roles and IDs
    mapping(address => bool) public isPatient;
    mapping(address => uint256) public patientIdsByAddress;

    // ID for the next patient
    uint256 public nextId;

    // Modifiers for access control
    modifier onlyDoctor() {
        require(
            msg.sender == responsibleDoctor,
            "Access restricted to Responsible Doctor."
        );
        _;
    }

    modifier onlyDirector() {
        require(
            msg.sender == regionalDirector,
            "Access restricted to Regional Director."
        );
        _;
    }

    modifier onlyMedia() {
        require(
            msg.sender == mediaNetwork,
            "Access restricted to Media Network."
        );
        _;
    }

    modifier onlyPatient() {
        require(
            isPatient[msg.sender],
            "Access restricted to the specific patient."
        );
        _;
    }

    // Constructor to initialize roles
    constructor(
        address _responsibleDoctor,
        address _regionalDirector,
        address _mediaNetwork
    ) {
        responsibleDoctor = _responsibleDoctor;
        regionalDirector = _regionalDirector;
        mediaNetwork = _mediaNetwork;
    }

    // Function to register a new patient
    function registerPatient(address patientAddress) public onlyDoctor {
        isPatient[patientAddress] = true;
    }

    // Function for the responsible doctor to add new patients
    function addPatient(
        address patientAddress,
        string memory cin,
        string memory firstName,
        string memory lastName,
        uint256 age,
        string memory gender,
        string memory region,
        string memory testResult
    ) public onlyDoctor {
        require(isPatient[patientAddress], "Patient must be registered first");

        patients.push(
            Patient(
                nextId,
                patientAddress,
                cin,
                firstName,
                lastName,
                age,
                gender,
                region,
                testResult
            )
        );
        patientIdsByAddress[patientAddress] = nextId;

        // Update statistics
        patientsByRegion[region]++;
        patientsByRegionAndGender[region][gender]++;
        uint8 ageGroup = _getAgeGroup(age);
        patientsByRegionAndAgeGroup[region][ageGroup]++;

        nextId++;
    }

    // Function for the responsible doctor to view patient details by ID
    function viewPatient(uint256 patientId)
        public
        view
        onlyDoctor
        returns (Patient memory)
    {
        require(patientId < nextId, "Patient not found.");
        return patients[patientId];
    }

    // Function for a patient to view their own information
    function viewMyInfo(address _patientAddress)
        public
        view
        returns (Patient memory)
    {
        uint256 patientId = patientIdsByAddress[_patientAddress];
        require(patientId < nextId, "Patient not found.");
        return patients[patientId];
    }

    // Function for the regional director to view statistics by region, gender, and age group
    function viewStatisticsByRegionGenderAge(
        string memory region,
        string memory gender,
        uint8 ageGroup
    ) public view onlyDirector returns (uint256) {
        return
            patientsByRegion[region] +
            patientsByRegionAndGender[region][gender] +
            patientsByRegionAndAgeGroup[region][ageGroup];
    }

    // Function for the media network to view the number of patients by region
    function viewPatientsByRegion(string memory region)
        public
        view
        onlyMedia
        returns (uint256)
    {
        return patientsByRegion[region];
    }

    // Internal function to categorize age groups
    function _getAgeGroup(uint256 age) internal pure returns (uint8) {
        if (age <= 18) return 1;
        else if (age <= 35) return 2;
        else if (age <= 50) return 3;
        else if (age <= 65) return 4;
        else return 5;
    }

    // Structures to define research subjects
    struct Subject {
        string code;
        string title;
        string[] questions;
    }

    // Mapping for storing subjects
    mapping(string => Subject) public subjects;
    uint256 public subjectCount;

    // Placeholder for analyst access control modifier
    modifier onlyAnalyst() {
        // Placeholder for actual analyst address control logic
        _;
    }

    // Function for analysts to create a research subject
    function addSubject(
        string memory code,
        string memory title,
        string[] memory questions
    ) public onlyAnalyst {
        subjects[code] = Subject(code, title, questions);
        subjectCount++;
    }

    // Structure to define a patient's response to a research subject
    struct PatientResponse {
        string answer;
    }

    // Mapping to store patient responses to research subjects
    mapping(uint256 => mapping(string => PatientResponse))
        public patientResponses;

    function recordPatientResponse(
        address patientAddress,
        string memory subjectCode,
        string memory response
    ) public {
        uint256 patientId = patientIdsByAddress[patientAddress];
        require(patientId < nextId, "Patient not found.");
        patientResponses[patientId][subjectCode] = PatientResponse(response);
    }

    // Function for analysts to view patient responses to research subjects
    function viewPatientResponses(uint256 patientId, string memory subjectCode)
        public
        view
        returns (PatientResponse memory)
    {
        require(patientId < nextId, "Patient not found.");
        return patientResponses[patientId][subjectCode];
    }
}
