const Orderbook = artifacts.require("Orderbook_V10.sol");
contract("Orderbook_V10", accounts => {
  it("should return the peak properly", function () {
    return Orderbook.deployed()
      .then(function (instance) {
        tokenInstance = instance;
        return tokenInstance.submitBid(10, 1, { from: accounts[1] });
      })
      .then(function (receipt) {
        return tokenInstance.BuyListpeak.call();
      })
      .then(function (order) {
        assert.equal(order[1].toNumber(), 10, "error in setting price");
        assert.equal(order[2].toNumber(), 1, "error in setting volume");
      });
  });
});
