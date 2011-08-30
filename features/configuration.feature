Feature: configuration
  In order to use this tool effectively,
  I want to configure it for my environment.

  Background:
    Given a file named "config/jcov.yml" with:
    """
    threshold: 76.8
    threshold_must_match: true
    """

  Scenario: it can print out its loaded configuration
    When I run `jcov check`
    Then the output should contain:
    """
    threshold: 76.8
    threshold_must_match: true
    """

  Scenario: it can have its configuration location overridden
    Given a file named "foo/bar.yml" with:
    """
    threshold: 10
    """
    When I run `jcov check --config=foo/bar.yml`
    Then the output should contain:
    """
    threshold: 10
    """

  Scenario: looks for its configuration in a set of logical places
    # Given a file named "jcov.yml" with:
    # """
    # threshold: 33
    # """
    # When I remove the file "config/jcov.yml"
    # When I run `jcov check`
    # Then the output should contain:
    # """
    # threshold: 33
    # """

  Scenario: configures where to look for the test files

  Scenario: configures what command to run to start the tests

  Scenario: configures where to look for the test files

  Scenario: has defaults for all the configuration values
