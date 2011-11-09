describe("mean.js", function () {
  beforeEach(function () {
    load("javascripts/mean.js");
  });

  describe("Math.prototype.mean", function () {
    it("returns the average for an array of numbers", function () {
      expect(Math.mean([1,2,3,4,5,10])).toEqual(4.166666666666667);
    });

    it("returns 0 for empty arrays", function () {
      expect(Math.mean([])).toEqual(0);
    });
  });
});
