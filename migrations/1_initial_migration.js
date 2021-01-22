const Migrations = artifacts.require("Migrations");

module.exports = function (deployer) {
  //deployer.deploy(Migrations, { gas: 1000000000 });
  deployer.deploy(Migrations);
};
