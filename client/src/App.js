import React, { Component } from "react";
import ItemManagerContract from "./contracts/ItemManager.json";
import ItemContract from "./contracts/Item.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = {cost: 0, itemName: "exampleItem1", loaded:false};
  
  componentDidMount = async () => {
    try {
    // Get network provider and web3 instance.
    this.web3 = await getWeb3();
    // Use web3 to get the user's accounts.
    this.accounts = await this.web3.eth.getAccounts();
    // Get the contract instance.
    //const networkId = await this.web3.eth.net.getId();
    this.networkId = await this.web3.eth.net.getId();

    this.itemManager = new this.web3.eth.Contract(
      ItemManagerContract.abi,
      ItemManagerContract.networks[this.networkId] && ItemManagerContract.networks[this.networkId].address,
      );
  
      this.item = new this.web3.eth.Contract(
        ItemContract.abi,
        ItemContract.networks[this.networkId] && ItemContract[this.networkId].address,
      );

    /*
    this.itemManager = new this.web3.eth.Contract(
    ItemManager.abi,
    ItemManager.networks[this.networkId] && ItemManager.networks[this.networkId].address,
    );

    this.item = new this.web3.eth.Contract(
    Item.abi,
    Item.networks[this.networkId] && ItemManagerContract[this.networkId].address,
    );
    */
    this.listenToPaymentEvent();
    /* In order to simulate payment, go to truffle development console and type truffle(develop)> web3.eth.sendTransaction( { to:"0xD32Ee0b0eC6Ecf5645fAD3306A004288b0E631d4", value:123, from:accounts[1], gas:300000 } );  
      substitute with respective address and value
    */
    this.setState({loaded:true});

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  handleSubmit = async () => {
    const { cost, itemName } = this.state;
    console.log(itemName, cost, this.itemManager);
    let result = await this.itemManager.methods.createItem(itemName, cost).send({ from:
    this.accounts[0] });
    console.log(result);
    alert("Send "+cost+" Wei to "+result.events.SupplyChainStep.returnValues._itemAddress);
    };
    
  listenToPaymentEvent = () => {
    let self = this;
    this.itemManager.events.SupplyChainStep().on("data", async function(evt) {
    
    if(evt.returnValues._step == 1) {
      let itemObj = await self.itemManager.methods.items(evt.returnValues._itemIndex).call(
      );
      console.log(itemObj);
      alert("Item " + itemObj._identifier + " was paid, deliver it now!");
      };
      console.log(evt);

    /* 
    console.log(evt);

    let itemObj = await self.itemManager.methods.items(evt.returnValues._itemIndex).call();
    alert("Item " + itemObj._identifier + " was successfully paid, deliver it now!");
    */

    })

  }

    handleInputChange = (event) => {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;
    this.setState({
    [name]: value
    });
    }

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
      }
      return (
      <div className="App">
      <h1>Simply Payment/Supply Chain Example!</h1>
      <h2>Items</h2>
      <h2>Add Element</h2>
      Cost: <input type="text" name="cost" value={this.state.cost} onChange={this.handleInputChange} />
      Item Name: <input type="text" name="itemName" value={this.state.itemName} onChange
      ={this.handleInputChange} />
      <button type="button" onClick={this.handleSubmit}>Create new Item</button>
      </div>
      );    
  }
}

export default App;
