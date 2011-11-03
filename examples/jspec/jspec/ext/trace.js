TraceOutput = {
  indent: 0,

  beforeSuite: function (suite) {
    if (this.indent == 0) print();
    this.printWithIndent(suite.description, 'white');
    this.indent += 1;
  },

  afterSuite: function (suite) {
    this.indent -= 1;
  },

  afterSpec: function (spec) {
    var color = (spec.requiresImplementation()) ? 'blue' : (spec.passed()) ? 'green' : 'red';
    var out = (spec.requiresImplementation()) ? ' [NOT IMPLEMENTED]' : (spec.passed()) ? '' : ' [FAILED]';
    this.printWithIndent(spec.description + out, color);
  },

  printWithIndent: function (out, color) {
    var prefix = ""
    for (var i = 0; i < this.indent; i++) {
      prefix += "  ";
    }
    print(JSpec.color(prefix + out, color));
  }
};
JSpec.include(TraceOutput);
