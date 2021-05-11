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
    
    function destroySmartContract(address payable _to) public{
        //This function its only avaliable to the owner of the SC.
        require(msg.sender == owner, "You're not the owner");
        //When the SC is destroyed, the funds of the account are transfered to a specific account.
        selfdestruct(_to);
    }    

}