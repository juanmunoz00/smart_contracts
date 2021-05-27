pragma solidity ^0.6.0;


/* 
    Implementing an ownable functionality
    To check https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
*/
contract Ownable{
    address payable _owner;
    
    constructor() public{
        _owner = msg.sender;
    }
    
    /* === This is all linked togehter === */
    /* A modifier "frames/packs" certain reusable functionality */
    modifier onlyOwner(){
        require(isOwner(), "You're not the owner");
        _;
    }
    
    function isOwner() public view returns(bool){
        return (msg.sender == _owner);
    }
    /* === This is all linked togehter === */
    
}
