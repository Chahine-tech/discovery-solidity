// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract FlightDelayInsurance {

    address public admin;
    
    bool public subscriptionsActive = true;

    struct Subscription {
        bool subscribed;
        bool delayValidated;
        bool refunded;
        bool disqualified;
    }

    mapping(address => Subscription) public subscriptions;
    address[] public usersWithDelays;
    uint public totalDelaysValidated;

    event Subscribed(address user);
    event DelayValidated(address user);
    event Refunded(address user);
    event SubscriptionDisabled(address user);
    event DelaysReset();

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute this function.");
        _;
    }

    modifier onlySubscribed() {
        require(subscriptions[msg.sender].subscribed, "User is not subscribed.");
        _;
    }

    modifier subscriptionsAllowed() {
        require(subscriptionsActive, "Subscriptions are currently disabled.");
        _;
    }

    constructor() {
        admin = msg.sender;
        totalDelaysValidated = 0;
    }

    function subscribe() public payable subscriptionsAllowed {
        require(msg.value >= 1 ether, "Subscription requires at least 1 ETH.");
        require(!subscriptions[msg.sender].subscribed, "User already subscribed.");

        subscriptions[msg.sender] = Subscription(true, false, false, false);
        emit Subscribed(msg.sender);
    }

    function validateDelay(address user) public onlyAdmin {
        require(subscriptions[user].subscribed, "User is not subscribed.");
        require(!subscriptions[user].delayValidated, "Delay already validated.");

        subscriptions[user].delayValidated = true;
        usersWithDelays.push(user);
        totalDelaysValidated++;
        emit DelayValidated(user);
    }

    function requestRefund() public onlySubscribed {
        require(subscriptions[msg.sender].delayValidated, "Delay not validated.");
        require(!subscriptions[msg.sender].refunded, "Already refunded.");
        require(!subscriptions[msg.sender].disqualified, "Subscription has been disabled.");
        require(address(this).balance >= 2 ether, "Insufficient contract balance for refund.");

        subscriptions[msg.sender].refunded = true;
        payable(msg.sender).transfer(2 ether);
        emit Refunded(msg.sender);
    }

    function viewStatus() public view returns (string memory) {
        if (subscriptions[msg.sender].disqualified) {
            return "Subscription Disabled";
        } else if (!subscriptions[msg.sender].subscribed) {
            return "Not Subscribed";
        } else if (subscriptions[msg.sender].refunded) {
            return "Refunded";
        } else if (subscriptions[msg.sender].delayValidated) {
            return "Delay Validated";
        } else {
            return "Subscribed";
        }
    }

    function getTotalDelaysValidated() public view returns (uint) {
        return totalDelaysValidated;
    }

    function disableSubscription(address user) public onlyAdmin {
        require(subscriptions[user].subscribed, "User is not subscribed.");

        subscriptions[user].disqualified = true;
        emit SubscriptionDisabled(user);
    }

    function resetDelays() public onlyAdmin {
        for (uint i = 0; i < usersWithDelays.length; i++) {
            address user = usersWithDelays[i];
            subscriptions[user].delayValidated = false;
            subscriptions[user].refunded = false;
        }
        delete usersWithDelays;
        totalDelaysValidated = 0;
        emit DelaysReset();
    }

    function getUsersWithDelays() public view returns (address[] memory) {
        return usersWithDelays;
    }

    function toggleSubscriptions(bool _state) public onlyAdmin {
        subscriptionsActive = _state;
    }

    function getSubscriptionState(address user) public view returns (bool subscribed, bool delayValidated, bool refunded, bool disqualified) {
        Subscription memory sub = subscriptions[user];
        return (sub.subscribed, sub.delayValidated, sub.refunded, sub.disqualified);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}