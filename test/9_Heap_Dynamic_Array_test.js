const Heap_Dynamic_Array = artifacts.require('Heap_Dynamic_Array');

contract('Heap_Dynamic_Array', function (accounts) {
  //*******************Test 1 (adding n elements to the Heap)*************************

  it('should store n orders to the Heap', async () => {
    const HeapInstance = await Heap_Dynamic_Array.deployed();

    var receipt = null;
    var array = [];
    accounts = await web3.eth.getAccounts();

    for (let j = 1; j <= 10; j++) {
      receipt = await HeapInstance.submitorder(j, 1, { from: accounts[0] });
      const gasUsed = receipt.receipt.gasUsed;
      array.push(gasUsed);
      console.log(
        `GasUsed for 1 submitorder tx is: ${receipt.receipt.gasUsed}`,
      );
    }
    // Getting sum of numbers
    //var sum = array.reduce(function(a, b){
    //return a + b;
    //}, 0);

    //console.log('cost of n submitorder txs is:',sum);
    console.log(array.length, 'orders has been succsessfully submitted');
    console.log('Gas used for submitting the', array.length, 'th order is:');
    console.log(`${receipt.receipt.gasUsed}`);

    console.log('*******************************************************');
    //const result1 = HeapInstance.MaxHeapPeak();
    //console.log(result1.toNumber());
    //const result = await HeapInstance.MaxHeapPeak.call();
    //const {0: addsender, 1: intprice, 2: auxprice, 2: intvolume} = result;
    //console.log('The SellList peak is:', intprice);
  });
  //*******************Test 2 (Removing n elements from the Heap)*************************

  // it('should remove n orders from the Heap', async() => {
  //     const HeapInstance = await Heap_Dynamic_Array.deployed();
  //     var receipt = null;
  //     var array = [];

  //     for(let j = 1; j <= 500 ; j++){
  //         receipt = await HeapInstance.MaxHeapDelete();
  //         const gasUsed = receipt.receipt.gasUsed;
  //         array.push(gasUsed);
  //         //console.log(`GasUsed for 1 MaxHeapDelete tx is: ${receipt.receipt.gasUsed}`);
  //     }
  //     // Getting sum of numbers
  //     //var sum = array.reduce(function(a, b){
  //         //return a + b;
  //     //}, 0);

  //     console.log(array.length,'orders has been succsessfully removed');
  //     console.log('Gas used for removing the', array.length,'th order is:');
  //     console.log(`${receipt.receipt.gasUsed}`);

  //console.log('cost of n MaxHeapDelete txs is:',sum);
  //console.log(array.length,'orders has been succsessfully removed');

  //});
});
