const DappToken = artifacts.require('DappToken');
const Orderbook = artifacts.require('Orderbook_V27');
var Orderbookaddress;
var tokenaddress;
var accounts;

contract('Orderbook', function(accounts) {
    it('should store the address of the orderbook into the var orderbookaddress', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        Orderbookaddress = OrderbookInstance.address;
        console.log('The address of the orderbook contract is:', OrderbookInstance.address);
        
    });




});

contract('DappToken', function(accounts) {

    it('should approve transfer of 100 tokens from account[0] to the orderbook contract ', async ()=> {
        const DappTokenInstance = await DappToken.deployed();
        tokenaddress = DappTokenInstance.address;
        const receipt = await DappTokenInstance.approve (Orderbookaddress, 15000, {from: accounts[0]});
        const result = await DappTokenInstance.allowance(accounts[0],Orderbookaddress);
        console.log('Account[0] allowes the orderbook contract to spend:',result.toNumber());
        
        console.log('********************************************');
        const gasUsed = receipt.receipt.gasUsed;
        console.log(`GasUsed for approving: ${receipt.receipt.gasUsed}`);
    
    });   

});


//*******************New test Block for the already deployed orderbook contract *************************
describe('Orderbook', function(accounts) {
    this.timeout(0);
    
    //*******************Test 1*************************
    it('should deposit 100 tokens from accounst[0] to the orderbook contract', async() => {
        
        const OrderbookInstance = await Orderbook.deployed(); 

        accounts = await web3.eth.getAccounts();
       
        const receipt = await OrderbookInstance.DepositToken (tokenaddress, 15000, {from: accounts[0]});
        
        const totalbalance = await OrderbookInstance.TokenBalance(accounts[0], tokenaddress);
        
        console.log('The token balance of account[0] is:', totalbalance.toNumber());
        console.log('********************************************');
        //const gasUsed = receipt.receipt.gasUsed;
        //console.log(`GasUsed for depositting 100 tokens: ${receipt.receipt.gasUsed}`);

    });

    //*******************Test 2*************************
    it('should deposit 6000 Ether from accounts[1] to the orderbook contract', async() => {
        
        const OrderbookInstance = await Orderbook.deployed(); 

        accounts = await web3.eth.getAccounts();
        
        const receipt = await OrderbookInstance.DepositEther (1000000, {from: accounts[1]});

        const totalbalance = await OrderbookInstance.EtherBalance(accounts[1]);
        
        console.log('The Ether balance of accounts[1] is:',totalbalance.toNumber());
        console.log('********************************************');
        //const gasUsed = receipt.receipt.gasUsed;
        //console.log(`GasUsed for depositting 6000 Ethers: ${receipt.receipt.gasUsed}`);
        
    });


    //*******************Test 3*************************

    it('should open the market on the Dapp Token', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 

        const receipt = await OrderbookInstance.OpenMarket (tokenaddress);
        const gasUsed = receipt.receipt.gasUsed;
        console.log(`GasUsed for openning the market: ${receipt.receipt.gasUsed}`);
        
    });

    //*******************Test 4*************************
    
    it('should submit 1 asks from accounst[0]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
            var receipt = null;
            var array = [];
        

            accounts = await web3.eth.getAccounts();
            for(let j = 20; j >= 1  ; j--){
                receipt = await OrderbookInstance.submitAsk (j, 1, {from: accounts[0]});
        
                //const gasUsed = receipt.receipt.gasUsed;
                //array.push(gasUsed);
                //console.log(`GasUsed for a submitAsk tx is: ${receipt.receipt.gasUsed}`);

            } 
            //console.log(array.length,'asks has been succsessfully submitted');
            //console.log('Gas used for submitting the', array.length,'th ask is:');
            //console.log(`${receipt.receipt.gasUsed}`);
        
   });

   
    //*******************Test 6*************************
    it('should submit 1 Bids from accounst[1]', async() => {
        
        const OrderbookInstance = await Orderbook.deployed(); 
        var receipt = null;
        var array = [];
        

        accounts = await web3.eth.getAccounts();
        for(let j = 1; j <= 20  ; j++){
            receipt = await OrderbookInstance.submitBid (j, 1, {from: accounts[1]});
        
            //const gasUsed = receipt.receipt.gasUsed;
            //array.push(gasUsed);
            //console.log(`GasUsed for a submibid tx is: ${receipt.receipt.gasUsed}`);

        } 
        //console.log(array.length,'bids has been succsessfully submitted');
        //console.log('Gas used for submitting the', array.length,'th bid is:');
        //console.log(`${receipt.receipt.gasUsed}`);
            
        
        
        
    });
   

    
    //*******************Test 8*************************
    it('should match the orders', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        
        const receipt = await OrderbookInstance.MatchOrders(tokenaddress);
        console.log('********************************************');
        const gasUsed = receipt.receipt.gasUsed;
        console.log(`GasUsed for Matching: ${receipt.receipt.gasUsed}`);
    
    });

    it('should show the countervariable', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        
        const counter = await OrderbookInstance.countervariable();
        console.log('********************************************');
        console.log('the countervariable is',counter.toNumber());
        console.log('********************************************');
        await OrderbookInstance.changetest();
        const test = await OrderbookInstance.test();
        console.log('the test is',test.toNumber());
    
    });
    //*******************Test 9*************************

    // it('should return both the total and available token balance of accounts[1]', async() => {
    //     const OrderbookInstance = await Orderbook.deployed(); 
        
    //     accounts = await web3.eth.getAccounts();
        
    //     const totalbalance = await OrderbookInstance.TotalTokenBalance(accounts[1], tokenaddress);
    //     const availablebalance = await OrderbookInstance.AvailableTokenBalance(accounts[1], tokenaddress);
        
    //     console.log('The total token balance of accounts[1] after trade is:',totalbalance.toNumber());
    //     console.log('The available token balance of accounts[1] after trade is:',availablebalance.toNumber());
    
    // });
    // //*******************Test 10*************************

    // it('should return both the total and available ether balance of accounts[0]', async() => {
    //     const OrderbookInstance = await Orderbook.deployed(); 
        

    //     accounts = await web3.eth.getAccounts();

    //     const totalbalance = await OrderbookInstance.TotalEtherBalance(accounts[0]);
    //     const availablebalance = await OrderbookInstance.AvailableEtherBalance(accounts[0]);
        
    //     console.log('The total Ether balance of accounts[0] after trade is:',totalbalance.toNumber());
    //     console.log('The available Ether balance of accounts[0] after trade is:',availablebalance.toNumber());

        
    
    // });
    //*******************Test 11*************************
    // it('should return the BuyList peak', async() => {
    //     const OrderbookInstance = await Orderbook.deployed(); 
    
    //     const result = await OrderbookInstance.BuyListPeak.call();
    //     const {0: addsender, 1: intprice, 2: auxprice, 2: intvolume} = result;
    //     console.log('The Buylist peak after match is:', intprice);

    // });
    

    // //*******************Test 13*************************
    // it('should return the SellList peak', async() => {
    //     const OrderbookInstance = await Orderbook.deployed(); 
    
    //     const result = await OrderbookInstance.SellListPeak.call();
    //     const {0: addsender, 1: intprice, 2: auxprice, 2: intvolume} = result;
    //     console.log('The SellList peak after match is:', intprice);

    // });
    
});