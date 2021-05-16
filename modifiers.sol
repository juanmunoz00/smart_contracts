pragma solidity ^0.5.13;

import "./owned.sol";

contract InheritanceModifierExample is Owned{
    //Ths contracts inherits/extends the functionality of the Owned contract
    mapping(address => uint) public tokenBalance;
    
    uint tokenPrice = 1 ether;
    
    constructor() public{
        tokenBalance[owner] = 100;
    }
    
    //These functions are implementing the modifier that validates that only the owner of the SC can execute them
    function createNewToken() public onlyOwner{
        tokenBalance[owner]++;
    }
    
    function burnNewToken() public onlyOwner{
        tokenBalance[owner]--;
    }    

    function purchaseToken() public payable{
        require((tokenBalance[owner] * tokenPrice) / msg.value > 0, "not enough tokens");
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }
    
    function sendToken(address _to, uint _amount) public{
        require(tokenBalance[msg.sender] >= _amount, "not enough tokens");
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
    }

}