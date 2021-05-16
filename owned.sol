pragma solidity ^0.5.13;

contract Owned{
    address owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        /*
        This is awesome!
        A modifier is a special type of function that can be called in writable functions
        so code can be reused.
        
        When a function invoques a modifier this gets a copy of the functionality in the modifier
        so it can interact with the code
        */
        require(msg.sender == owner, "You're not the owner");
        _;
    }
}