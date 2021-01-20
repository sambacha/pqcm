const linkedlist = artifacts.require("Sorted_linkedlist_V3");
//var assert = require('assert');

contract("linkedlist", function (accounts) {
  //*******************Test 1*************************
  it("should insert Item", async () => {
    const linkedlistInstance = await linkedlist.deployed();

    await linkedlistInstance.insert(2);
    await linkedlistInstance.insert(1);
    await linkedlistInstance.remove(2);
    await linkedlistInstance.displaylist();
  });

  //*******************Test 2*************************
  it("should should pass if the list contains the daata ", async () => {
    const linkedlistInstance = await linkedlist.deployed();
    const result = await linkedlistInstance.contains.call(2);
    assert.equal(result, true, "The data does not exist in the list"); //actual,expected
  });
  //*******************Test 2*************************
  it("should should pass if the list contains the data ", async () => {
    const linkedlistInstance = await linkedlist.deployed();
    const result = await linkedlistInstance.contains.call(2);
    assert.equal(result, true, "The data does not exist in the list"); //actual,expected
  });
});
