const PQ = artifacts.require("PQ5.sol");
var maximum = 200;
var minimum = 1;

//Uint Testing the Priority Queues:
//This truffle code tests 5 priority queues. We just insert 50 random integers (between 0 and 200) and then remove them to see how much gas it consumes.
//Delverables: The Gas Used for removing 50 numbers, Gas Refund, and the actual Gas Cost (Gasestimate)

contract("PQ", function (accounts) {
  //******************* Test 1*************************
  it("should insert 50 random integers", async () => {
    const PQInstance = await PQ.deployed();
    var receipt = null;
    var array = [];

    for (let j = 1; j <= 50; j++) {
      var randomnumber = Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
      receipt = await PQInstance.Enqueue(randomnumber);
      const gasUsed = receipt.receipt.gasUsed;
      console.log(`GasUsed for a inserting the integer is: ${receipt.receipt.gasUsed}`);
      array.push(randomnumber);
    }
    console.log(array.length, "integers have been succsessfully inserted");
  });
  //******************* Test 2*************************
  it("should return the Gasestimate for removing 50 integers from the list", async () => {
    const PQInstance = await PQ.deployed();
    const gasEstimate = await PQInstance.Dequeue.estimateGas();
    console.log("Gas Estimate is:", gasEstimate);
  });

  //*******************Test 3*************************
  it("should remove 50 numbers from the list", async () => {
    const PQInstance = await PQ.deployed();

    const receipt = await PQInstance.Dequeue();
    console.log(`GasUsed for Dequeueing 50 numbers is : ${receipt.receipt.gasUsed}`);
  });
});
