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
    """
    When I run `rake jspec`
    Then the output should contain:
    """
    foo
    """
