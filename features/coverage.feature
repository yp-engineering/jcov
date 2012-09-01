Feature: coverage
  In order to make sure code is being executed
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

  Scenario: it will report coverage
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (4/7) 57.1%
    """

  Scenario: it will not report coverage when disabled
    When I run `jcov --no-coverage`
    Then the output should not contain:
    """
    Total Coverage:
    """

  Scenario: it will report slightly more coverage
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    two();
    error_count = 0;
    """
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (6/7) 85.7%
    """

  Scenario: it will report full coverage
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    three();
    error_count = 0;
    """
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (7/7) 100.0%
    """

  Scenario: it reports correctly if we don't load any files
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    """
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (0/7) 0.0%
    """

  Scenario: it will report coverage across all files even if they're not loaded
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    three();
    error_count = 0;
    """
    And a file named "public/javascripts/bar.js" with:
    """
    var foo = 1;
    var bar = 2;
    var baz = 3;
    """
    When I run `jcov`
    Then the output should contain:
    """
    Total Coverage: (7/10) 70.0%
    """

  Scenario: reports an error message if the coverage is below the threshold
    Given a file named "jcov.yml" with:
    """
    threshold: 80
    """
    When I run `jcov`
    Then the output should contain:
    """
    FAIL! Coverage is lower than threshold! 57.1% < 80% :(
    """

  Scenario: doesn't report an error message if the coverage is above the threshold
    Given a file named "jcov.yml" with:
    """
    threshold: 40
    """
    When I run `jcov`
    Then the output should not contain:
    """
    FAIL!
    """

  Scenario: reports an error message if the coverage is above the threshold and threshold_must_match == true
    Given a file named "jcov.yml" with:
    """
    threshold: 40
    threshold_must_match: true
    """
    When I run `jcov`
    Then the output should contain:
    """
    Coverage does not match threshold! 57.1% != 40%
    """

  Scenario: tells you where to update threshold if it does not match
    Given a file named "jcov.yml" with:
    """
    threshold: 40
    threshold_must_match: true
    """
    When I run `jcov`
    Then the output should contain:
    """
    Please raise the threshold in ./jcov.yml
    """

  Scenario: tells you where to update threshold if it does not match even if the file is not in a typical location
    Given a file named "foo/bar/jcov.yml" with:
    """
    threshold: 40
    threshold_must_match: true
    """
    When I run `jcov --config foo/bar/jcov.yml`
    Then the output should contain:
    """
    Please raise the threshold in foo/bar/jcov.yml
    """

  Scenario: doesn't report a threshold error message if the threshold is not set
    When I run `jcov`
    Then the output should not contain:
    """
    FAIL!
    """

  Scenario: returns a zero exit status if coverage is above the threshold
    Given a file named "jcov.yml" with:
    """
    threshold: 40
    """
    When I run `jcov`
    And the exit status should be 0

  Scenario: returns a non-zero exit status if coverage is below the threshold
    Given a file named "jcov.yml" with:
    """
    threshold: 80
    """
    When I run `jcov`
    And the exit status should not be 0

  Scenario: returns a non-zero exit status if coverage is above the threshold and threshold_must_match == true
    Given a file named "jcov.yml" with:
    """
    threshold: 40
    threshold_must_match = true
    """
    When I run `jcov`
    Then the exit status should not be 0

  Scenario: gives a helpful message if no files were checked for coverage
    Given a file named "jcov.yml" with:
    """
    ignore:
      - foo
    """
    When I run `jcov`
    Then the output should contain:
    """
    No files were checked for coverage. Maybe your ignore list in ./jcov.yml is too inclusive?
    """

  Scenario: don't check coverage if we're running focused tests
    Given a file named "jcov.yml" with:
    """
    threshold: 80
    """
    When I run `jcov public/javascripts/foo.js`
    Then the exit status should be 1
    And the output should not contain "FAIL"
    And the output should not contain "Total Coverage"

  Scenario: don't check coverage if we're running regex focused tests
    Given a file named "jcov.yml" with:
    """
    threshold: 80
    """
    When I run `jcov --test foo`
    Then the exit status should be 1
    And the output should not contain "FAIL"
    And the output should not contain "Total Coverage"


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
