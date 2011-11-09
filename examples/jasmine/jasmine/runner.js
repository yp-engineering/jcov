var exports = {};
var setTimeout    = function () {};
var clearTimeout  = function () {};
var setInterval   = function () {};
var clearInterval = function () {};

load("jasmine/jasmine.js");
load("jasmine/ConsoleReporter.js");

var tests = JCov.tests;
var testCount = tests.length;
for (var i = 0; i < testCount; i++) {
  load(tests[i]);
}

var jasmineEnv = jasmine.getEnv();
// so jasmine doesn't use setTimeout for running tests asyncronously
jasmineEnv.updateInterval = false;

var complete = function (runner) {
  results = runner.results().failedCount;
};

// TODO put this ability into jcov itself
var printNoNewline = function (string) {
  var length = string.length;
  for (var i = 0; i < length; i++) {
    putc(string.charAt(i));
  }
};

var reporter = new jasmine.ConsoleReporter(printNoNewline, complete, JCov.options.color);

jasmineEnv.addReporter(reporter);

jasmineEnv.execute();
