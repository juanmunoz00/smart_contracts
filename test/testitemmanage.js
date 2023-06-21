const ItemManager = artifacts.require("./contracts/ItemManager.sol");

/// In Truffle, it starts with contract
contract("ItemManager", accounts => {
    it("... should be able to add an item", async function() {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 500;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, {from: accounts[0]});
        console.log(result);


    })

});