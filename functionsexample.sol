pragma solidity ^0.5.13;

contract FunctionExample{
    mapping(address => uint) public balanceReceived;
    
    address payable owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    
    function getOwner() public view returns(address){
        /*
            A view function only displays a value/stored variable as read only.
            A view function cannot call a write function.
        */
        return owner;
    }
    
    function convertWeiToEther(uint _amountInWei) public pure returns (uint){
        /*
            A pure function does not interact with stored variables (class variables)
            The scope of the pure function is only within its definition
            
            A pure function can call another pure function BUT CANNOT CALL a view or write function.
        */
        return _amountInWei / 1 ether;
    }
    
     function DestroySmartContract() public {
        //Validating that the executer of the SC is the owner so the contract is only. 
        require(msg.sender == owner, "You're not the owner");
        selfdestruct(owner);
     }
     
     function receiveMoney() public payable {
         /*Validating that the amount being trnsfered will increment the balance
            using assert to do a validation invariance (between variables)
         */
         assert(balanceReceived[msg.sender] + msg.value >= balanceReceived[msg.sender]);
         balanceReceived[msg.sender] += msg.value;
     }

    function withdrawMoney(address payable _to, uint _amount) public {
        //Checks effects interaction pattern
        //Interaction with the SC comes last, everything needs to be updated first         
        require(_amount <= balanceReceived[msg.sender], "not enough funds");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        _to.transfer(_amount);
    }
    
    function () external payable{
        /*
        This is a fallback function:
        It's called when "there's no function that matches" in order to prevent exceptions throwned.
        It's also used when there's no function that interacts with the "exterior".
        
        
        
        */
        receiveMoney();
    }
    
    
}