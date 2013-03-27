// JSpec reporter uses print as println
print = println;

load('jspec/lib/jspec.js');

load('jspec/ext/slowness.js')

JSpec._globalScope = this;

JSpec._globals = {};
// capture the current globals
JSpec.captureGlobals = function () {
  for (var i in JSpec._globalScope) {
    JSpec._globals[i] = true;
  }
};
// remove globals we haven't previously captured
JSpec.cullGlobals = function () {
  for (var i in JSpec._globalScope) {
    if (!JSpec._globals[i]) {
      delete JSpec._globalScope[i];
    }
  }
};

if (JCov.config.verbose) {
  load('jspec/ext/trace.js')
} else {
  JSpec.include({
    afterSpec: function (spec) {
      putc((spec.requiresImplementation()) ? '*' : (spec.passed()) ? '.' : 'F');
    }
  });
}

JSpec.include({
  afterSuite: function (suite) {
    if (!suite.name) { // it's the top level suite
      JSpec.cullGlobals();
    }
  }
});

// defining quit so jspec doesn't complain
quit = function () {
};

TESTS = JCov.tests;

if (TESTS.length == 1) {
  print("Testing '"+TESTS[0]+"'");
}

thing = JSpec;
for (var i = 0; i < TESTS.length; i++) {
  thing = thing.exec(TESTS[i]);
}

JSpec.captureGlobals();

thing
.run({reporter:      JSpec.reporters.Terminal,
      failuresOnly:  true,
      fixturePath:   'jspec/fixtures',
      disableColors: !JCov.config.color})
.report();
