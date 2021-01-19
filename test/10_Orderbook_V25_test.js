const DappToken = artifacts.require('DappToken');
const Orderbook = artifacts.require('Orderbook_V25');
var Orderbookaddress;
var tokenaddress;
var accounts;

contract('Orderbook', function(accounts) {
    
    //*******************Test 1*************************
    it('should submit 1 asks from accounst[0]', async() => {
        const OrderbookInstance = await Orderbook.deployed(); 
        var receipt = null;
        var array = [];
        

        accounts = await web3.eth.getAccounts();
        for(let j = 1; j <= 100  ; j++){
            receipt = await OrderbookInstance.submitAsk (j, 1, {from: accounts[0]});
        
            const gasUsed = receipt.receipt.gasUsed;
            array.push(gasUsed);
            console.log(`GasUsed for a submitask tx is: ${receipt.receipt.gasUsed}`);

        } 
        
        // Getting sum of numbers
        // var sum = array.reduce(function(a, b){
        //     return a + b;
        // }, 0);

        console.log(array.length,'asks has been succsessfully submitted');
        console.log('Gas used for submitting the', array.length,'th ask is:');
        console.log(`${receipt.receipt.gasUsed}`);
        console.log('********************************************');

        
   });
//*******************Test 2*************************

   it('should submit 1 Bids from accounst[1]', async() => {
    const OrderbookInstance = await Orderbook.deployed(); 
    var receipt = null;
    var array = [];
   
    accounts = await web3.eth.getAccounts();
    for(let j = 1; j <= 100 ; j++){

        receipt = await OrderbookInstance.submitBid (j, 1, {from: accounts[1]});

        const gasUsed = receipt.receipt.gasUsed;
        array.push(gasUsed);
        console.log(`GasUsed for a submibid tx is: ${receipt.receipt.gasUsed}`);

    } 
    console.log(array.length,'bids has been succsessfully submitted');
    console.log('Gas used for submitting the', array.length,'th bid is:');
    console.log(`${receipt.receipt.gasUsed}`);
    
});
//*******************Test 3*************************
    it('should match the orders', async() => {
    const OrderbookInstance = await Orderbook.deployed(); 
    
    
    
    const receipt = await OrderbookInstance.MatchOrders();
    
    


    console.log('********************************************');
    const gasUsed = receipt.receipt.gasUsed;
    console.log(`GasUsed for Matching: ${receipt.receipt.gasUsed}`);
    
    //const contract = new web3.eth.Contract(OrderbookInstance.abi, OrderbookInstance.address);

    //Now get evens depending on what you need
    //contract.getPastEvents("allEvents", {fromBlock: 0, toBlock: "latest"}) .then(console.log) ;



});

   



});



