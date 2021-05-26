var Itemmanager = artifacts.require("./Itemmanager.sol");

module.exports = function(deployer) {
  deployer.deploy(Itemmanager);
};
