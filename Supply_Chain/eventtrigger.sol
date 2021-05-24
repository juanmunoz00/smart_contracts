pragma solidity ^0.6.0;

contract ItemManager{
    
    /* Enumeration to define an item state/stage/phase */
    
    //enum FreshJuiceSize{ SMALL, MEDIUM, LARGE }
    enum SupplyChainState{ Created, Paid, Delivered }
    
    struct S_Item {
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    event SupplyChainStep(uint _itemIndex, uint _step);
    
    /* Structure handling */
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    /* Create an item with the provided attributes */
    function createItem(string memory _identifier, uint _itemPrice) public{
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));//Communicate to the "outside world" (SC)
        itemIndex++;
        
    }
    
    /* When a payment is received, and it covers the price, change the state.
        Is payable because it'll receive a payment (transfer)
    */
    function triggerPayment(uint _itemIndex) public payable{
        
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted !");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain !");
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(itemIndex, uint(items[_itemIndex]._state));//Communicate to the "outside world" (SC)
    }
    
    function triggerDelivery(uint _itemIndex) public {
        
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain !");
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(itemIndex, uint(items[_itemIndex]._state));//Communicate to the "outside world" (SC)
    }
    
}