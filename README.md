Certainly! Here's the updated README:

# Message Escrow Application

A simple message escrow application that manages the secure sending and receipt confirmation of messages between two parties.

## Description

This program is a simple message escrow application that simulates a secure messaging system where a sender can send a message, and the receiver can confirm its receipt.

## Getting Started

### Executing program

To run the program, you can use Remix, an online Solidity IDE. Here's the step-by-step instruction on how to make this work:

1. Go to Remix: [Remix IDE](https://remix.ethereum.org/)
2. Create a new file in Remix and copy the code from the `main.sol` file (provided below).
3. Compile the code with the compiler set to version 0.8.4.
4. Deploy and run the code.

### Code (main.sol)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

```solidity
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
```

## Authors

Renz Angelo Aguirre

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
