var CallMarket = artifacts.require("./CallMarket.sol");
// var PQ1 = artifacts.require("./HeapDynamicArray.sol");
// var PQ2 = artifacts.require("./HeapStaticArray.sol");
// var PQ3 = artifacts.require("./HeapMapping.sol");
// var PQ4 = artifacts.require("./LinkedList.sol");
// var PQ5 = artifacts.require("./LinkedListMapping.sol");
// var MP = artifacts.require("./Mapping.sol");
// var PQaddress;

//const BN = require('bn.js');

// module.exports = async function(deployer) {
//     deployer.deploy(modularExp).then(() => {
//         return deployer.deploy(modularExp);
//     }).then(async () => {
//         //var modularExp = await modularExp.deployed();
//         await modularExp.js_call();
//     });
//     };
// module.exports = function (deployer) {
//     deployer.deploy(PQ1);
//     console.log("I was deployed!");
// };

// // module.exports =  function (deployer) {

// //     deployer.deploy(PQ2, 60).then (function(){
// //         return deployer.deploy(CallMarket, PQ2.address)

// //     });

// //     console.log("I was deployed!");

// // };
// module.exports = function (deployer) {
//     deployer.deploy(PQ2);
//     console.log("I was deployed!");
// };
// module.exports = function (deployer) {
//     deployer.deploy(PQ3);
//     console.log("I was deployed!");
// };
// module.exports = function (deployer) {
//     deployer.deploy(PQ4);
//     console.log("I was deployed!");
// };

module.exports = function (deployer) {
  //deployer.deploy(CallMarket,{overwrite: false});
  deployer.deploy(CallMarket);
  console.log("CallMarket was deployed!");
};

// module.exports = function (deployer) {
//     deployer.deploy(MP);
//     console.log("I was deployed!");
// };

// module.exports = function (deployer) {
//     deployer.deploy(Int).then(() => {
//         deployer.deploy(CallMarket);
//     });
//     deployer.link(Int, User);
// };
