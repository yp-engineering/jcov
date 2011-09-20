Feature: reporting
  In order to know how much of our code is being executed
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
    And a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """

  Scenario: does not show a console coverage report unless asked
    When I run `jcov`
    Then the output should not contain:
    """
    Coverage Report
    """

  Scenario: shows a console coverage report when asked
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
    Given a file named "public/javascripts/bar.js" with:
    """
    var foo = 1;
    var bar = 2;
    var baz = 3;
    """
    When I run `jcov --report`
    Then the output should match:
    """
    public/javascripts/foo.js\s+\(4/7\)\s+57%
    """
    And the output should match:
    """
    public/javascripts/bar.js\s+\(0/3\)\s+0%
    """

  Scenario: only report on files actually run if --test is provided
    Given a file named "public/javascripts/bar.js" with:
    """
    var foo = 1;
    var bar = 2;
    var baz = 3;
    """
    When I run `jcov --report --test foo`
    Then the output should match:
    """
    public/javascripts/foo.js\s+\(4/7\)\s+57%
    """
    And the output should not contain:
    """
    public/javascripts/bar.js
    """

  Scenario: does not report on the runner if it's in the scripts directory
    Given a file named "public/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    error_count = 0;
    """
    And a file named "jcov.yml" with:
    """
    test_runner: public/javascripts/runner.js
    """
    When I run `jcov --report`
    Then the output should match:
    """
    public/javascripts/foo.js\s+\(4/7\)\s+57%
    """
    And the output should not contain:
    """
    public/javascripts/runner.js
    """

  Scenario: reports files as empty
    Given a file named "public/javascripts/bar.js" with:
    """
    """
    When I run `jcov --report`
    Then the output should match:
    """
    public/javascripts/bar.js\s+\(EMPTY\)\s+100%
    """
