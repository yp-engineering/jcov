Feature: test runner
  In order to test my Javascript without opening a browser
  I want to use a tool that runs my tests headless.

  Background:
    Given a file named "Rakefile" with:
    """
    $:.unshift(File.dirname(__FILE__) + '/../../lib')
    load '../../lib/tasks/jcov.rake'
    """

  @announce
  Scenario: runs jspec
    Given a file named "jspec/v8.js" with:
    """
    print('foo');
    JSpec = { stats: { failures:0 } };
    """
    When I run `rake jspec`
    Then the output should contain:
    """
    foo
    """

  @announce
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

  @announce
  Scenario: reports the number of failures
    Given a file named "jspec/v8.js" with:
    """
    JSpec = { stats: { failures:3 } };
    """
    When I run `rake jspec`
    Then the output should contain:
    """
    JSpec Test Failures! :(
    """
