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

var reporter = new jasmine.ConsoleReporter(print, complete, JCov.options.color);

jasmineEnv.addReporter(reporter);

jasmineEnv.execute();
