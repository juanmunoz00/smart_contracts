import React, { Component } from "react";
//import SimpleStorageContract from "./contracts/SimpleStorage.json";
import ItemmanagerContract from './contracts/ItemManager.json';
import ItemContract from './contracts/Item.json';
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded: false, cost: 0, itemName:"example_1"};

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();
      //const deployedNetwork = ItemmanagerContract.networks[networkId];
      this.itemmanager = new this.web3.eth.Contract(
        ItemmanagerContract.abi,
        ItemmanagerContract.networks[this.networkId] && ItemmanagerContract.networks[this.networkId].address,
        //deployedNetwork && deployedNetwork.address,
      );

      this.item = new this.web3.eth.Contract(
        ItemContract.abi,
        ItemContract.networks[this.networkId] && ItemContract.networks[this.networkId].address,
        //deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ loaded:true });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

handleInputChange = (event) => {
  
  const target = event.target;
  //Establish the item value
  const value = target.type === "checkbox" ? target.checked : target.value;
  const name = target.name;

  //Establish the state
  this.setState({
    [name]: value
  });

}

handleSubmit = async() => {

  const { cost, itemName } = this.state;
  //Send this values to the SC in the BCH.
  let result = await this.itemmanager.methods.createItem(itemName, cost).send({from: this.accounts[0]});
  let resultMsg = "Send " + cost + " wei to " + result.events.SupplyChainStep.returnValues._itemAddress;
  console.log(result);
  
  //alert("Send " + cost + " wei to " + result.events.SupplyChainStep.returnValues._itemAddress);
  var confirmMsg = document.getElementById("confirm_msg");
  confirmMsg.removeAttribute("hidden");
  confirmMsg.innerHTML = resultMsg;

}

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">

        <h1>Event Trigger / Supply Chain Example</h1>
        <h2>Items</h2>
        <h2>Add Items</h2>
        Cost in Wei: <input type="text" name="cost" value={ this.state.cost } onChange={this.handleInputChange} />
        Item Identifier: <input type="text" name="itemName" value={ this.state.item } onChange={this.handleInputChange} />
        <button type="button" onClick={this.handleSubmit}>Create a new item</button>
        <div>
          <p id="confirm_msg" hidden></p>
        </div>
        
      </div>
    );
  }
}

export default App;
