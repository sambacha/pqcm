const CallMarket = artifacts.require('CallMarket.sol');
const DappToken = artifacts.require('DappToken');
var CallMarketaddress;
var tokenaddress;
var accounts;
var maximum = 100;
var minimum = 1;

//Test 2:
//This truffle code tests 5 priority queues in terms of the number of matches the match function can handle.
//Note: this is a "normal/average case" matching where we use random prices for Bids and Asks and obviously not all of them will be executed against each other.
//The deliverables of this code are: (1) The maximum number of orders the match function can match (2) How much gas it uses (which should be close to the limit)

//******************* Deploys the CallMaket and stores its address *************************
contract('CallMarket', function (accounts) {
  it('should store the address of the CallMarket into the var CallMarketaddress', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    CallMarketaddress = CallMarketInstance.address;
    console.log(
      'The address of the CallMarket contract is:',
      CallMarketInstance.address,
    );
  });
});
//******************* Deploys the DappToken and allows CallMarket to spend tokens from it *************************
contract('DappToken', function (accounts) {
  it('should approve transfer of 100 tokens from account[0] to the CallMarket contract ', async () => {
    const DappTokenInstance = await DappToken.deployed();
    tokenaddress = DappTokenInstance.address;
    //accounts = await web3.eth.getAccounts();
    //console.log(accounts[0].address);
    const balance = await DappTokenInstance.balanceOf(accounts[0]);
    const receipt = await DappTokenInstance.approve(CallMarketaddress, 15000, {
      from: accounts[0],
    });
    //const result = await DappTokenInstance.allowance(accounts[0],CallMarketaddress);
    //console.log('Account[0] allowes the CallMarket contract to spend:',result.toNumber());
    console.log('********************************************');
    console.log('account[0] DappToken balance is:', balance.toNumber());
    console.log('********************************************');
  });
});

//*******************New test Block for the already deployed CallMarket contract *************************
describe('CallMarket', function (accounts) {
  this.timeout(0);

  //*******************Test 1*************************
  it('should deposit tokens from accounst[0] to the CallMarket contract', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    accounts = await web3.eth.getAccounts();
    const receipt = await CallMarketInstance.depositToken(tokenaddress, 15000, {
      from: accounts[0],
    });

    const totalTokenbalance = await CallMarketInstance.totalTokenBalance(
      accounts[0],
    );
    const totalEtherbalance = await CallMarketInstance.totalEtherBalance(
      accounts[0],
    );

    console.log(
      'The token balance of account[0] (Bob) is:',
      totalTokenbalance.toNumber(),
    );
    console.log(
      'The Ether balance of account[0] (Bob) is:',
      totalEtherbalance.toNumber(),
    );
    console.log('********************************************');
  });

  //*******************Test 2*************************
  it('should deposit Ethers from accounts[1] to the CallMarket contract', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    accounts = await web3.eth.getAccounts();

    await CallMarketInstance.depositEther({
      from: accounts[1],
      value: 10000000000,
    });

    const totalEtherbalance = await CallMarketInstance.totalEtherBalance(
      accounts[1],
    );
    const totalTokenbalance = await CallMarketInstance.totalTokenBalance(
      accounts[1],
    );

    console.log(
      'The Ether balance of accounts[1] (Alice) is:',
      totalEtherbalance.toNumber(),
    );
    console.log(
      'The token balance of accounts[1] (Alice) is:',
      totalTokenbalance.toNumber(),
    );
    console.log('********************************************');
    const num = await CallMarketInstance.getBalance();
    console.log('The Ether balance of Lissy is:', num.toNumber());
    console.log('********************************************');
  });
  //*******************Test 3*************************

  it('should open the market on the Dapp Token', async () => {
    const CallMarketInstance = await CallMarket.deployed();

    const receipt = await CallMarketInstance.openMarket();
    const gasUsed = receipt.receipt.gasUsed;
    console.log(`GasUsed for openning the market: ${receipt.receipt.gasUsed}`);
    console.log('********************************************');
  });
  //*******************Test 4*************************

  it('should submit asks from accounst[0]', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    var receipt = null;
    var array = [];

    accounts = await web3.eth.getAccounts();
    for (let j = 1; j <= 5; j++) {
      var randomnumber1 =
        Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
      var randomnumber2 =
        Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;

      await CallMarketInstance.submitAsk(randomnumber1, randomnumber2, {
        from: accounts[0],
      });
      array.push(randomnumber1);

      console.log(
        'Ask',
        j,
        'price and volume are equal to:',
        randomnumber1,
        randomnumber2,
      );
    }
    console.log(array.length, 'asks has been succsessfully submitted');
  });
  //*******************Test 5*************************
  it('should submit Bids from accounst[1]', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    var receipt = null;
    var array = [];

    accounts = await web3.eth.getAccounts();
    for (let j = 1; j <= 5; j++) {
      var randomnumber1 =
        Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
      var randomnumber2 =
        Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
      await CallMarketInstance.submitBid(randomnumber1, randomnumber2, {
        from: accounts[1],
      });
      array.push(randomnumber1);
      console.log(
        'Bid',
        j,
        'price and volume are equal to:',
        randomnumber1,
        randomnumber2,
      );
    }
    console.log(array.length, 'bids has been succsessfully submitted');
  });
  //*******************Test 6*************************
  it('should close the market on the Dapp Token', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    await CallMarketInstance.closeMarket();
  });

  //*******************Test 7*************************
  it('should match the orders', async () => {
    const CallMarketInstance = await CallMarket.deployed();
    const receipt = await CallMarketInstance.matchOrders();
    console.log('********************************************');
    const gasUsed = receipt.receipt.gasUsed;
    console.log(
      `GasUsed for worst case matching is: ${receipt.receipt.gasUsed}`,
    );
  });
  //*******************Test 8*************************
  it('should print how many matches happened', async () => {
    const CallMarketInstance = await CallMarket.deployed();

    const counter = await CallMarketInstance.countervariable();
    console.log('********************************************');
    console.log('Number of matches occured:', counter.toNumber());
    console.log('********************************************');
  });
});
