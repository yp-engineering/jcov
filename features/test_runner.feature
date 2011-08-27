Feature: test runner
  In order to test my Javascript without opening a browser
  I want to use a tool that runs my tests headless.

  Background:
    Given a file named "Rakefile" with:
    """
    $:.unshift(File.dirname(__FILE__) + '/../../lib')
    load '../../lib/tasks/jcov.rake'
    """

  Scenario: runs jspec
    Given a file named "jspec/v8.js" with:
    """
    JSpec = { stats: { failures:0 } };
    print('foo');
    """
    When I run `rake jspec`
    Then the output should contain:
    """
    foo
    """

  Scenario: reports success
    Given a file named "jspec/v8.js" with:
    """
    JSpec = { stats: { failures:0 } };
    """
    When I run `rake jspec`
    Then the output should not contain:
    """
    JSpec Test Failures! :(
    """
    And the exit status should be 0

  Scenario: reports the failures
    Given a file named "jspec/v8.js" with:
    """
    JSpec = { stats: { failures:3 } };
    """
    When I run `rake jspec`
    Then the output should contain:
    """
    JSpec Test Failures! :(
    """
    And the exit status should not be 0

  @wip
  Scenario: provides the test framework the set of tests to run
