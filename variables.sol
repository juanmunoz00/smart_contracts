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
    
}