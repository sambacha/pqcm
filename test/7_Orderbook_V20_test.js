const Orderbook = artifacts.require('Orderbook_V20');

contract('Orderbook_V20', function(accounts) {
    

    it('accounts[0] should deposit 10 tokens properly', async()=>{
        const OrderbookInsatnce = await Orderbook.deployed();
        await OrderbookInsatnce.DepositToken ("0xBe3F7D10F1B03b779dC2C27518bc430839427b81", 10, {from: accounts[0]});
        const result = await OrderbookInsatnce.TokenBalance(accounts[0], "0xBe3F7D10F1B03b779dC2C27518bc430839427b81");
        console.log(result.toNumber());



    });




});