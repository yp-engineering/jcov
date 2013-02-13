Feature: javascript interface
  In order for my javascript test framework to run inside of jcov
  it needs to have a set of interface methods

  Scenario: I want to print a line
    Given a file named "test/javascripts/runner.js" with:
    """
    println('foo');
    println('bar');
    """
    When I run `jcov`
    Then the output should contain:
    """
    foo
    bar
    """

  Scenario: I want to print a line without a carrage return
    Given a file named "test/javascripts/runner.js" with:
    """
    print('foo');
    print('bar');
    """
    When I run `jcov`
    Then the output should contain:
    """
    foobar
    """

  Scenario: I want to print a single character
    Given a file named "test/javascripts/runner.js" with:
    """
    putc('.');
    putc('.');
    putc('.');
    """
    When I run `jcov`
    Then the output should contain:
    """
    ...
    """

  Scenario: I want to read the contents of a file as a string
    Given a file named "test/javascripts/runner.js" with:
    """
    var contents = readFile('foo.txt');
    print(contents);
    """
    And a file named "foo.txt" with:
    """
    foo contents
    """
    When I run `jcov`
    Then the output should contain:
    """
    foo contents
    """

  Scenario: I want to load a javascript file and have it executed
    Given a file named "test/javascripts/runner.js" with:
    """
    load("test.js");
    """
    And a file named "test.js" with:
    """
    print("here I am");
    """
    When I run `jcov`
    Then the output should contain:
    """
    here I am
    """

  Scenario: I want to find where I made an error in my runner file
    Given a file named "test/javascripts/runner.js" with:
    """
    // this is a comment
    // this is another comment
    var foo = 1;
    var bar = 2;
    var baz = 3;
    fail();
    """
    When I run `jcov --trace`
    Then the output should match:
    """
    test/javascripts/runner.js:6:\d+: fail is not defined
    """

  Scenario: I want to find where I made an error in tested Javascript
    Given a file named "test/javascripts/runner.js" with:
    """
    load("public/javascripts/foo.js");
    """
    And a file named "public/javascripts/foo.js" with:
    """
    // this is a comment
    // this is another comment
    var foo = 1;
    var bar = 2;
    var baz = 3;
    fail();
    """
    When I run `jcov --trace`
    Then the output should match:
    """
    public/javascripts/foo.js:6:\d+: fail is not defined
    """
