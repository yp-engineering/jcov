Feature: instrumentation
  In order to report coverage statistics
  I need to instrument the running javascript

  Background:
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """

  Scenario: it dumps instrumented file contents when a flag is set
    Given a file named "public/javascripts/foo.js" with:
    """
    var bar = 0;
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);var bar = 0;
    """

  Scenario: functions should be covered
    Given a file named "public/javascripts/foo.js" with:
    """
    function foo() {
      var bar = 0;
    }
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);function foo() {
    _coverage_tick('public/javascripts/foo.js', 2);  var bar = 0;
    }
    """

  Scenario: ignores comments
    Given a file named "public/javascripts/foo.js" with:
    """
    // one
    // two
    var bar = 0;
    // three
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    // one
    // two
    _coverage_tick('public/javascripts/foo.js', 3);var bar = 0;
    // three
    """

  Scenario: it handles object definitions with function values
    Given a file named "public/javascripts/foo.js" with:
    """
    var obj = {
      foo: function () {
        var test = 0;
      }
    };

    obj.foo();
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);var obj = {
      foo: function () {
    _coverage_tick('public/javascripts/foo.js', 3);    var test = 0;
      }
    };

    _coverage_tick('public/javascripts/foo.js', 7);obj.foo();
    """

  Scenario: it handles else if statements correctly
    Given a file named "public/javascripts/foo.js" with:
    """
    if (false) {
      var one = 1;
    }
    else if (true) {
      var two = 2;
    }
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);if (false) {
    _coverage_tick('public/javascripts/foo.js', 2);  var one = 1;
    }
    else if (true) {
    _coverage_tick('public/javascripts/foo.js', 5);  var two = 2;
    }
    """

  Scenario: it handles broken up if statements
    Given a file named "public/javascripts/foo.js" with:
    """
    var foo = 3;
    if (foo > 1 &&
        foo < 8) {
      var bar = 2;
    }
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);var foo = 3;
    _coverage_tick('public/javascripts/foo.js', 2);if (foo > 1 &&
        foo < 8) {
    _coverage_tick('public/javascripts/foo.js', 4);  var bar = 2;
    }
    """

  Scenario: it handles weirdly formatted case statements
    Given a file named "public/javascripts/foo.js" with:
    """
    var foo = 'bar';
    switch (foo) {
      case 'bar': wibble = 1;
        break;
      case 'baz': wibble = 2;
        break;
      default:
        wibble = 3;
    }
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);var foo = 'bar';
    _coverage_tick('public/javascripts/foo.js', 2);switch (foo) {
      case 'bar': wibble = 1;
    _coverage_tick('public/javascripts/foo.js', 4);    break;
      case 'baz': wibble = 2;
    _coverage_tick('public/javascripts/foo.js', 6);    break;
      default:
    _coverage_tick('public/javascripts/foo.js', 8);    wibble = 3;
    }
    """

  Scenario: it handles stupid formatting with grace
    Given a file named "public/javascripts/foo.js" with:
    """
    var foo = 1
      , bar = 2
      , baz = function () { var wibble = 3; };
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);var foo = 1
      , bar = 2
      , baz = function () { var wibble = 3; };
    """

  Scenario: it still handles multiline functions within stupid formatting
    Given a file named "public/javascripts/foo.js" with:
    """
    var foo = 1
      , bar = 2
      , baz = function () {
          var wibble = 3;
        };
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);var foo = 1
      , bar = 2
      , baz = function () {
    _coverage_tick('public/javascripts/foo.js', 4);      var wibble = 3;
        };
    """

  Scenario: it handles if..else statements without parens gracefully
    Given a file named "public/javascripts/foo.js" with:
    """
    if (foo)
      bar = 1;
    else
      baz = 3;
    """
    When I run `jcov --dump`
    Then the output should contain:
    """
    _coverage_tick('public/javascripts/foo.js', 1);if (foo)
      bar = 1;
    else
      baz = 3;
    """
