pragma solidity ^0.5.13;

contract MappingStructureExample{
    //A mapping works as a dictionary with a key and a value;
    //This mapping is to pair an address and its account balance
    mapping(address => uint) public balanceReceived;
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function sendMoney() public payable{
        //A payable specifies will be dealing with addresses
        balanceReceived[msg.sender] += msg.value;
    }
    
    function withdrawMoney(address payable _to, uint amount) public{
        //Checks effects interaction patter
        require(balanceReceived[msg.sender] >= amount, "not enough funds");
        balanceReceived[msg.sender] -= amount;
        _to.transfer(amount);
    }
    
    function withdrawAllMoney(address payable _to) public{
        //Checks effects interaction patter
        //Interaction with the SC comes last, everything needs to be updated first 
        uint balanceToSend = balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0;
        _to.transfer(balanceToSend);
    }
    
}