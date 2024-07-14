// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MessageEscrow {
    enum State { NONE, AWAITING_MESSAGE, AWAITING_CONFIRMATION, COMPLETE }

    address public sender;
    address public receiver;
    State public currentState;
    address public owner;
    string public message;

    modifier onlySender() {
        require(msg.sender == sender, "Only the sender can call this function");
        _;
    }

    modifier onlyReceiver() {
        require(msg.sender == receiver, "Only the receiver can call this function");
        _;
    }

    modifier inState(State expectedState) {
        require(currentState == expectedState, "Invalid state");
        _;
    }

    constructor(address _sender, address _receiver) {
        sender = _sender;
        receiver = _receiver;
        currentState = State.AWAITING_MESSAGE;
        owner = msg.sender;
    }

    function sendMessage(string memory _message) public onlySender inState(State.AWAITING_MESSAGE) {
        require(bytes(_message).length > 0, "Message must be non-empty");
        message = _message;
        currentState = State.AWAITING_CONFIRMATION;

        assert(bytes(message).length > 0);
        assert(currentState == State.AWAITING_CONFIRMATION);
    }

    function confirmReceipt() public onlyReceiver inState(State.AWAITING_CONFIRMATION) {
        currentState = State.COMPLETE;

        assert(currentState == State.COMPLETE);
    }

    function resetEscrow() public {
        if (msg.sender != owner) {
            revert("Only the owner can reset the escrow");
        }
        
        message = "";
        currentState = State.AWAITING_MESSAGE;
    }
}
