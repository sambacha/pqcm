const CallMarket = artifacts.require("CallMarket.sol");
const DappToken = artifacts.require("DappToken");
var CallMarketaddress;
var tokenaddress;
var accounts;
var maximum = 100;
var minimum = 1;

//Test 4:
//This truffle code tests 5 priority queues when 200 bids and 200 asks are entered in randomordering.
//The deliverables of this code are: a chart with x-axis being the place in line (10th person to submit) and y-axis being gas

//******************* Deploys the CallMaket and stores its address *************************
contract("CallMarket", function (accounts) {
  it("should store the address of the CallMarket into the var CallMarketaddress", async () => {
    const CallMarketInstance = await CallMarket.deployed();
    CallMarketaddress = CallMarketInstance.address;
    console.log("The address of the CallMarket contract is:", CallMarketInstance.address);
  });
});
//******************* Deploys the DappToken and allows CallMarket to spend tokens from it *************************

contract("DappToken", function (accounts) {
  it("should approve transfer of 100 tokens from account[0] to the CallMarket contract ", async () => {
    const DappTokenInstance = await DappToken.deployed();
    tokenaddress = DappTokenInstance.address;
    const receipt = await DappTokenInstance.approve(CallMarketaddress, 15000, { from: accounts[0] });
    const result = await DappTokenInstance.allowance(accounts[0], CallMarketaddress);
    console.log("Account[0] allowes the CallMarket contract to spend:", result.toNumber());
    console.log("********************************************");
  });
});

//*******************New test Block for the already deployed CallMarket contract *************************
describe("CallMarket", function (accounts) {
  this.timeout(0);

  //*******************Test 1*************************
  it("should deposit tokens from accounst[0] to the CallMarket contract", async () => {
    const CallMarketInstance = await CallMarket.deployed();

    accounts = await web3.eth.getAccounts();

    const receipt = await CallMarketInstance.depositToken(tokenaddress, 15000, { from: accounts[0] });

    const totalbalance = await CallMarketInstance.TotalTokenBalance(accounts[0]);

    console.log("The token balance of account[0] is:", totalbalance.toNumber());
    console.log("********************************************");
  });

  //*******************Test 2*************************
  it("should deposit Ethers from accounts[1] to the CallMarket contract", async () => {
    const CallMarketInstance = await CallMarket.deployed();

    accounts = await web3.eth.getAccounts();

    const receipt = await CallMarketInstance.depositEther(1000000, { from: accounts[1] });

    const totalbalance = await CallMarketInstance.TotalEtherBalance(accounts[1]);

    console.log("The Ether balance of accounts[1] is:", totalbalance.toNumber());
    console.log("********************************************");
  });
  //*******************Test 3*************************

  it("should open the market on the Dapp Token", async () => {
    const CallMarketInstance = await CallMarket.deployed();

    const receipt = await CallMarketInstance.OpenMarket();
    const gasUsed = receipt.receipt.gasUsed;
    console.log(`GasUsed for openning the market: ${receipt.receipt.gasUsed}`);
  });
  //*******************Test 4*************************

  it("should submit asks from accounst[0]", async () => {
    const CallMarketInstance = await CallMarket.deployed();
    var receipt = null;
    var array = [];

    accounts = await web3.eth.getAccounts();
    for (let j = 1; j <= 200; j++) {
      var randomnumber = Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
      receipt = await CallMarketInstance.submitAsk(randomnumber, 1, { from: accounts[0] });
      const gasUsed = receipt.receipt.gasUsed;
      //console.log(`GasUsed for a submitAsk tx is: ${receipt.receipt.gasUsed}`);
      //console.log(`${receipt.receipt.gasUsed}`);
      array.push(j);
      console.log(randomnumber);
    }
    console.log(array.length, "asks have been succsessfully submitted");
  });

  //*******************Test 5*************************
  it("should submit Bids from accounst[1]", async () => {
    const CallMarketInstance = await CallMarket.deployed();
    var receipt = null;
    var array = [];

    accounts = await web3.eth.getAccounts();
    for (let j = 1; j <= 200; j++) {
      var randomnumber = Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
      receipt = await CallMarketInstance.submitBid(randomnumber, 1, { from: accounts[1] });
      const gasUsed = receipt.receipt.gasUsed;
      //console.log(`GasUsed for a submitBid tx is: ${receipt.receipt.gasUsed}`);
      console.log(`${receipt.receipt.gasUsed}`);
      array.push(j);
    }
    console.log(array.length, "bids have been succsessfully submitted");
  });
});
