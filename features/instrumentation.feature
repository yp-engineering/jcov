Feature: instrumentation
  In order to report coverage statistics
  I need to instrument the running javascript

  Background:
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """

  Scenario: functions should be reported as covered
    Given a file named "public/javascripts/foo.js" with:
    """
    function foo() {
      var bar = 0;
    }
    """
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (1/2) 50.0%
    """

  Scenario: ignores comments
    Given a file named "public/javascripts/foo.js" with:
    """
    // one
    // two
    var bar = 0;
    // three
    """
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (1/1) 100.0%
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
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (3/3) 100.0%
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
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (2/3) 66.7%
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
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (3/3) 100.0%
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
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (3/5) 60.0%
    """
