pragma solidity ^0.5.13;

contract MappingStructureExample{
    //A mapping works as a dictionary with a key and a value;
    //This mapping is to pair an address and its account balance
    
    //In this iteration 2 structures will be used to handle transactions more efficiently
    struct Payment{
        uint amount;
        uint timeStamps;
    }
    
    struct Balance{
        uint totalBalance;
        uint numPayments; //Struct index
        mapping(uint => Payment) payments;
    }
    
    //mapping(address => uint) public balanceReceived;
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function sendMoney() public payable{
        //A payable specifies will be dealing with addresses
        //balanceReceived[msg.sender] += msg.value;
        
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        //Referenced typed (??) this is stored in memory
        Payment memory payment = Payment(msg.value, now);
        //The payment value is stored in the Balance structure with the numPayments index
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        balanceReceived[msg.sender].numPayments++;
        
    }
    
    function withdrawMoney(address payable _to, uint amount) public{
        //Checks effects interaction patter
        require(balanceReceived[msg.sender].totalBalance >= amount, "not enough funds");
        balanceReceived[msg.sender].totalBalance -= amount;
        _to.transfer(amount);
    }
    
    function withdrawAllMoney(address payable _to) public{
        //Checks effects interaction patter
        //Interaction with the SC comes last, everything needs to be updated first 
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
    
}