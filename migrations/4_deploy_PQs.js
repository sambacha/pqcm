var PQ1 = artifacts.require("./PQ1.sol");
var PQ2 = artifacts.require("./PQ2.sol");
var PQ3 = artifacts.require("./PQ3.sol");
var PQ4 = artifacts.require("./PQ4.sol");
var PQ5 = artifacts.require("./PQ5.sol");
var test1 = artifacts.require("./test1.sol");

module.exports = function (deployer) {
  deployer.deploy(PQ1);
  deployer.deploy(PQ2);
  deployer.deploy(PQ3);
  deployer.deploy(PQ4);
  deployer.deploy(PQ5);
  deployer.deploy(test1);
};
