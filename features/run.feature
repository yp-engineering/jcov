Feature: test runner
  In order to test my Javascript without opening a browser
  I want to use a tool that runs my tests headless.

  Scenario: runs the runner.js file
    Given a file named "test/javascripts/runner.js" with:
    """
    print('foo');
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
    JSpec Test Failures! :(
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
    JSpec Test Failures! :(
    """
    And the exit status should not be 0

  # @wip
  # Scenario: provides the test framework the set of tests to run
