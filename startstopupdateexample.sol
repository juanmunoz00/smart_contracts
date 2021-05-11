pragma solidity ^0.5.13;

contract StartStopUpdateExample{
    address owner;
    
    bool public paused;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function sendMoney() public payable{
        
    }
    
    function setPaused(bool _paused) public{
        require(msg.sender == owner, "You're not the owner");
        paused = _paused;
        
    }
    
    //Same for the transfer, block by asserting with the require function.
    
}