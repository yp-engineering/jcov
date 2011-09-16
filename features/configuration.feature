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
    Given a file named "jcov.yml" with:
    """
    threshold: 33
    """
    When I remove the file "config/jcov.yml"
    When I run `jcov check`
    Then the output should contain:
    """
    threshold: 33
    """

  Scenario: uses its default configuration if it can't find a configuration file
    When I remove the file "config/jcov.yml"
    When I run `jcov check`
    Then the output should contain:
    """
    source_directory: public/javascripts
    """

  Scenario: it merges configuration with the defaults
    When I run `jcov check`
    Then the output should contain:
    """
    source_directory: public/javascripts
    """
    And the output should contain:
    """
    threshold: 76.8
    """

  Scenario: it complains if we provide a configuration file that doesn't exist
    When I run `jcov check --config=not/a/file.yml`
    Then the output should contain:
    """
    Cannot find file "not/a/file.yml"
    """

  Scenario: configures where to look for the test files
    When I run `jcov check`
    Then the output should contain:
    """
    test_directory:
    """

  Scenario: configures where to find the source files
    When I run `jcov check`
    Then the output should contain:
    """
    source_directory:
    """

  Scenario: configures which javascript file runs the tests
    When I run `jcov check`
    Then the output should contain:
    """
    test_runner:
    """

  Scenario: configures where to look for errors in javascript land
    When I run `jcov check`
    Then the output should contain:
    """
    error_field:
    """

  Scenario: has defaults for all the configuration values
    When I remove the file "config/jcov.yml"
    When I run `jcov check`
    Then the output should contain:
    """
    test_directory: test/javascripts
    """
    And the output should contain:
    """
    source_directory: public/javascripts
    """
    And the output should contain:
    """
    test_runner: test/javascripts/runner.js
    """
    And the output should contain:
    """
    error_field: error_count
    """
    And the output should contain:
    """
    report_output_directory: jcov
    """

  Scenario: it prints out what file it is using
    When I run `jcov check`
    Then the output should contain:
    """
    Using configuration file: config/jcov.yml
    """

  Scenario: if it can't find a file it tells us that
    When I remove the file "config/jcov.yml"
    When I run `jcov check`
    Then the output should contain:
    """
    No configuration file! Using defaults.
    """
