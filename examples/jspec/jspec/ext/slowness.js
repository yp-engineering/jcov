SlownessOutput = {
  slowSpecs: [],

  currentSpecTime: null,

  beforeSpec: function (spec) {
    this.currentSpecTime = new Date();
  },

  afterSpec: function (spec) {
    var time = (new Date()).getTime() - this.currentSpecTime.getTime();

    var index = 0;
    for (var i = 0; i < this.slowSpecs.length; i++) {
      if (time > this.slowSpecs[i].time) {
        break;
      }
      index++;
    }

    if (index < 5) {
      for (var i = this.slowSpecs.length-1; i > index; i--) {
        if (i < 5 && i > 0) this.slowSpecs[i] = this.slowSpecs[i-1];
      }

      this.slowSpecs[index] = {
        spec: spec,
        time: time
      };
    }
  },

  reporting: function (options) {
    if (this.slowSpecs.length > 0) {
      print("\n\nTop 5 Slowest jspecs:\n")
      for (var i = 0; i < this.slowSpecs.length; i++) {
        var slow = this.slowSpecs[i];
        print(JSpec.color(slow.time + 'ms', 'red') + ' ' + slow.spec.suite.description + ' ' + slow.spec.description);
      }
    }
  }
};
JSpec.include(SlownessOutput);
