pragma solidity ^0.5.13;

contract WorkingWithVariables {
    uint256 public myUint;
    
    function setMyUint(uint _myUint) public{
        myUint = _myUint;
    }
    
    bool public myBool;
    
    function setMyBool(bool _myBool) public{
        myBool = _myBool;
    }
    
    //A variation from the course
    function increaseUnit() public{
        myUint++;
    }
    
    function decreaseUnit() public{
        myUint--;
    }
    
    address public myAddress;
    
    function setAddress(address _myAddress) public{
        myAddress = _myAddress;
        
    }
    
    function getBalanceOfAddress() public view returns(uint){
        return myAddress.balance;
    }
    
    string public myString;
    
    function setMyString(string memory _myString) public{
        myString = _myString;
    }
    
    
}