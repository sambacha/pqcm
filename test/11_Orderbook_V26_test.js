const Orderbook = artifacts.require('Orderbook_V26');
//var assert = require('assert');


contract('Orderbook', function(accounts) {

    // it('should find out the gas limit for the latest block', async ()  =>{
    //     const OrderbookInstance = await Orderbook.deployed(); 
        
    //     var block = web3.eth.getBlock();
    //     console.log("gasLimit: " + block.gasLimit);
        
        

    // });
    
   //*******************Test 1*************************
    it('should submit 1 Buys from accounst[1]', async ()  =>{
        const OrderbookInstance = await Orderbook.deployed(); 
        var receipt = null;
        var array = [];
   
        accounts = await web3.eth.getAccounts();
        for(let j = 1; j <= 375 ; j++){

            receipt = await OrderbookInstance.submitBid (j, {from: accounts[1]});

            const gasUsed = receipt.receipt.gasUsed;
            array.push(gasUsed);
            console.log(`GasUsed for a submibid tx is: ${receipt.receipt.gasUsed}`);

        } 
        console.log(array.length,'bids has been succsessfully submitted');
        console.log('Gas used for submitting the', array.length,'th bid is:');
        console.log(`${receipt.receipt.gasUsed}`);
        

    });
    //*******************Test temp*************************
    // it ('is just a test to check the head of the buylist', async ()  =>{
    //     const OrderbookInstance = await Orderbook.deployed(); 
        

    //     await  OrderbookInstance.changetest();
    //     result = await OrderbookInstance.test();
    //     console.log('********************************************');
    //     console.log("the price of the buylist head is", result.toNumber());

    // });

    //*******************Test 2*************************

    // it('should should pass if the Buylist contains the data ', async ()  =>{
        
    //     const OrderbookInstance = await Orderbook.deployed(); 
    //     const result = await  OrderbookInstance.BuyListContains.call(35); 
    //     assert.equal( result, true, "The data does not exist in the list"); //actual,expected
    // });
     
    //*******************Test 3*************************
    it('should submit 1 asks from accounst[0]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        var receipt = null;
        var array = [];
        

        accounts = await web3.eth.getAccounts();
        for(let j = 375; j >= 1  ; j--){
            receipt = await OrderbookInstance.submitAsk (j, {from: accounts[0]});
        
            const gasUsed = receipt.receipt.gasUsed;
            array.push(gasUsed);
            console.log(`GasUsed for a submitask tx is: ${receipt.receipt.gasUsed}`);

        } 

        console.log(array.length,'asks has been succsessfully submitted');
        console.log('Gas used for submitting the', array.length,'th ask is:');
        console.log(`${receipt.receipt.gasUsed}`);
        console.log('********************************************');

        
   });



   //*******************Test 4*************************
   it('should match the orders', async() => {
    const OrderbookInstance = await Orderbook.deployed(); 
    
    const receipt = await OrderbookInstance.MatchOrders();
    console.log('********************************************');
    const gasUsed = receipt.receipt.gasUsed;
    console.log(`GasUsed for Matching: ${receipt.receipt.gasUsed}`);


    });
    //*******************Test 4*************************
    it('should show the countervariable', async() => {
    const OrderbookInstance = await Orderbook.deployed(); 
    
    const counter = await OrderbookInstance.countervariable();
    console.log('********************************************');
    console.log('the countervariable is',counter.toNumber());
    console.log('********************************************');
    const test = await OrderbookInstance.test();
    console.log('the test is',test.toNumber());

    });


    // it ('is just a test to check the head of the buylist', async ()  =>{
    //     const OrderbookInstance = await Orderbook.deployed(); 
        

    //     await  OrderbookInstance.changetest();
    //     result = await OrderbookInstance.test();
    //     console.log('********************************************');
    //     console.log("the price of the buylist head is", result.toNumber());

    // });


});


