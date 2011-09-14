Feature: reporting
  In order to know which code is being executed
  I want to report coverage statistics

  Background:
    Given a file named "public/javascripts/foo.js" with:
    """
    var one = "foo";                  // 1
    var z = 0;                        // 2

    var two = function () {           // 3
      for (var i = 0; i < 10; i++) {  // 4
        z++;                          // 5
      }
    };

    var three = function () {         // 6
      two();                          // 7
    };

    """

  Scenario: does not show a console coverage report unless asked
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """
    When I run `jcov`
    Then the output should not contain:
    """
    Coverage Report
    """

  Scenario: shows a console coverage report when asked
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """
    When I run `jcov --report`
    Then the output should contain:
    """
    Coverage Report
    """
    And the output should match:
    """
    public/javascripts/foo.js\s+\(4/7\)\s+57%
    """

  Scenario: reports on multiple files
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """
    And a file named "public/javascripts/bar.js" with:
    """
    var foo = 1;
    var bar = 2;
    var baz = 3;
    """
    When I run `jcov --report`
    Then the output should contain:
    """
    Coverage Report
    """
    And the output should match:
    """
    public/javascripts/foo.js\s+\(4/7\)\s+57%
    """
    And the output should match:
    """
    public/javascripts/bar.js\s+\(0/3\)\s+0%
    """
