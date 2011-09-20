Feature: HTML Report
  In order to know which exact lines are being executed
  And to explore our source code
  I want a persistant coverage report in HTML

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

  Scenario: reports to an HTML file
    When I run `jcov --report`
    Then a file named "jcov/report.html" should exist

  Scenario: the report has a list of ran files
    When I run `jcov --report`
    And I open the report
    Then I should see these values:
      |public/javascripts/foo.js|(4/7)|57%|
