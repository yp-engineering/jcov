Feature: test runner
  In order to test my Javascript without opening a browser
  I want to use a tool that runs my tests headless.

  Background:
    Given a file named "public/javascripts/foo.js" with:
    """
    var z = 0;
    """

  Scenario: runs the runner.js file
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    println('foo');
    """
    When I run `jcov`
    Then the output should contain:
    """
    foo
    """

  Scenario: reports success
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    """
    When I run `jcov`
    Then the output should not contain:
    """
    Test Failures! :(
    """
    And the exit status should be 0

  Scenario: reports the failures
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 3;
    """
    When I run `jcov`
    Then the output should contain:
    """
    Test Failures! :(
    """
    And the exit status should not be 0

  Scenario: provides the test framework the set of tests to run
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    var t = JCov.tests;
    for (var i = 0; i < t.length; i++) {
      println(t[i]);
    }
    """
    And an empty file named "test/javascripts/foo_test.js"
    And an empty file named "test/javascripts/wazzle/bar_test.js"
    When I run `jcov`
    Then the output should contain:
    """
    test/javascripts/foo_test.js
    test/javascripts/wazzle/bar_test.js
    """
    And the output should not contain:
    """
    test/javascripts/runner.js
    """

  Scenario: allows the user to run a focused test
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    var t = JCov.tests;
    for (var i = 0; i < t.length; i++) {
      println(t[i]);
    }
    """
    And an empty file named "test/javascripts/foo_test.js"
    And an empty file named "test/javascripts/wazzle/bar_test.js"
    When I run `jcov --test test/javascripts/wazzle/bar_test.js`
    Then the output should contain:
    """
    test/javascripts/wazzle/bar_test.js
    """
    And the output should not contain:
    """
    test/javascripts/foo_test.js
    """

  Scenario: allows the user to run a focused test without the --test switch
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    var t = JCov.tests;
    for (var i = 0; i < t.length; i++) {
      println(t[i]);
    }
    """
    And an empty file named "test/javascripts/foo_test.js"
    And an empty file named "test/javascripts/wazzle/bar_test.js"
    When I run `jcov test/javascripts/wazzle/bar_test.js`
    Then the output should contain:
    """
    test/javascripts/wazzle/bar_test.js
    """
    And the output should not contain:
    """
    test/javascripts/foo_test.js
    """

  Scenario: allows the user to run multiple focused tests
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    var t = JCov.tests;
    for (var i = 0; i < t.length; i++) {
      println(t[i]);
    }
    """
    And an empty file named "test/javascripts/foo_test.js"
    And an empty file named "test/javascripts/wazzle/bar_test.js"
    And an empty file named "test/javascripts/furble/baz_test.js"
    When I run `jcov test/javascripts/wazzle/bar_test.js test/javascripts/furble/baz_test.js`
    Then the output should contain:
    """
    test/javascripts/furble/baz_test.js
    test/javascripts/wazzle/bar_test.js
    """
    And the output should not contain:
    """
    test/javascripts/foo_test.js
    """

  Scenario: allows the user to match tests with a regex
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    var t = JCov.tests;
    for (var i = 0; i < t.length; i++) {
      println(t[i]);
    }
    """
    And an empty file named "test/javascripts/foo_test.js"
    And an empty file named "test/javascripts/wazzle/bar_test.js"
    When I run `jcov --test "wa[z]{2}le"`
    Then the output should contain:
    """
    test/javascripts/wazzle/bar_test.js
    """
    And the output should not contain:
    """
    test/javascripts/foo_test.js
    """

  Scenario: configuration is available to the javascript context
    Given a file named "jcov.yml" with:
    """
    threshold: 33
    """
    And a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    println(JCov.config.threshold);
    """
    When I run `jcov`
    Then the output should contain:
    """
    33
    """

  Scenario: user can enable verbose mode
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    println(JCov.config.verbose);
    """
    When I run `jcov --verbose`
    Then the output should contain:
    """
    true
    """

  Scenario: user can disable color output
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    println(JCov.config.color);
    """
    When I run `jcov --no-color`
    Then the output should contain:
    """
    false
    """

  Scenario: user can enable color output
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    println(JCov.config.color);
    """
    When I run `jcov --color`
    Then the output should contain:
    """
    true
    """

  Scenario: color defaults to off in a non-interactive shell (which cucumber is)
    Given a file named "test/javascripts/runner.js" with:
    """
    error_count = 0;
    println(JCov.config.color);
    """
    When I run `jcov`
    Then the output should contain:
    """
    false
    """
