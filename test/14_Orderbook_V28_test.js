const Orderbook = artifacts.require('Orderbook_V28');

contract('Orderbook', function (accounts) {
  //*******************Test 1*************************
  it('should insert asks', async () => {
    const OrderbookInstance = await Orderbook.deployed();

    var receipt = null;
    var array = [];

    accounts = await web3.eth.getAccounts();
    for (let j = 20; j >= 1; j--) {
      receipt = await OrderbookInstance.SellListInsert(j, {
        from: accounts[0],
      });

      const gasUsed = receipt.receipt.gasUsed;
      array.push(gasUsed);
      console.log(`GasUsed for a submitask tx is: ${receipt.receipt.gasUsed}`);
    }

    console.log(array.length, 'asks has been succsessfully submitted');
    console.log('Gas used for submitting the', array.length, 'th ask is:');
    console.log(`${receipt.receipt.gasUsed}`);
    console.log('********************************************');
  });
  //*******************Test 2*************************
  it('should insert Buys', async () => {
    const OrderbookInstance = await Orderbook.deployed();

    var receipt = null;
    var array = [];

    accounts = await web3.eth.getAccounts();
    for (let j = 1; j <= 20; j++) {
      receipt = await OrderbookInstance.BuyListInsert(j, { from: accounts[1] });

      const gasUsed = receipt.receipt.gasUsed;
      array.push(gasUsed);
      console.log(`GasUsed for a submitbid tx is: ${receipt.receipt.gasUsed}`);
    }

    console.log(array.length, 'bids has been succsessfully submitted');
    console.log('Gas used for submitting the', array.length, 'th ask is:');
    console.log(`${receipt.receipt.gasUsed}`);
    console.log('********************************************');

    await OrderbookInstance.testfunction();
    const test = await OrderbookInstance.buytest();
    console.log('test is', test.toNumber());
  });
});
