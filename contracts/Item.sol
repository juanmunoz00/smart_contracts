pragma solidity ^0.6.0;

import "./Itemmanager.sol";
contract Item{
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager partentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public{
        priceInWei = _priceInWei;
        index = _index;
        partentContract = _parentContract;
    }
    
    /* Callback function to handle the money receipet to send it to Item Manager */
    receive() external payable{
        //address(partentContract).transfer(msg.value);
        /* We'll use a called 'low level function' to ensure transaction has the 
            needed amount of gas to be executed
            
            Call the trigger payment to handle the payment.
            
            It's CRUCIALLY IMPORTANT to get the return value...
            
            The call gives you two return values:
            1) A boolean if the transaccion was successful an 
            2) The return of the function
            
        */
        require(pricePaid == 0, "Item's already paid !");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        (bool success, ) = address(partentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction was not successful, canceling!");
    }
    
    fallback() external {} //Interact from external with contract.
    
}