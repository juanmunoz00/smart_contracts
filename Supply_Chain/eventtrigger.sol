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

contract ItemManager is Ownable{
    
    /* Enumeration to define an item state/stage/phase */
    
    //enum FreshJuiceSize{ SMALL, MEDIUM, LARGE }
    enum SupplyChainState{ Created, Paid, Delivered }
    
    struct S_Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);
    
    /* Structure handling */
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    /* Create an item with the provided attributes */
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex); //Instantiating the contract that'll handle the items
        
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));//Communicate to the "outside world" (SC)
        itemIndex++;
        
    }
    
    /* When a payment is received, and it covers the price, change the state.
        Is payable because it'll receive a payment (transfer)
    */
    function triggerPayment(uint _itemIndex) public payable{
        
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted !");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain !");
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));//Communicate to the "outside world" (SC)
    }
    
    function triggerDelivery(uint _itemIndex) public onlyOwner{
        
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain !");
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));//Communicate to the "outside world" (SC)
    }
    
}