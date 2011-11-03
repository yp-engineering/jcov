describe("mean.js", function () {
  before(function () {
    load("javascripts/mean.js");
  });

  describe("Math.prototype.mean", function () {
    it("returns the average for an array of numbers", function () {
      Math.mean([1,2,3,4,5,10]).should.equal 4.166666666666667
    });

    it("returns 0 for empty arrays", function () {
      Math.mean([]).should.equal 0
    });
  });
});
