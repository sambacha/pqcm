var DappToken = artifacts.require("./DappToken.sol"); 
module.exports = function (deployer) {
    //deployer.deploy(DappToken, 10000000, {overwrite: false});
    deployer.deploy(DappToken, 10000000000);
    console.log("DappToken was deployed!");
    

};