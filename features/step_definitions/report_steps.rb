RSpec::Matchers.define :have_line do |this_line|
  match do |lines|
    regex = Regexp.new(Regexp.escape(this_line))
    lines.any? {|line| line =~ regex}.should be_true
  end
  failure_message_for_should do |list|
    # generate and return the appropriate string.
    "did not find \"#{this_line}\""
  end
  failure_message_for_should_not do |list|
    "found \"#{this_line}\""
  end
end

Given /^I open the report$/ do
  visit "/report.html"
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content text
end

Then /^I should see "([^"]*)" in the HTML$/ do |text|
  page.html.should match Regexp.new(Regexp.escape(text))
end

Then /^I should see these lines (covered|not covered|uncoverable):$/ do |type, table|

  # find all the lines of the given type
  lines = case type
          when 'covered'
            all('.line[data-coverage!="0"][data-coverage!="uncoverable"] .code')
          when 'not covered'
            all('.line[data-coverage="0"] .code')
          when 'uncoverable'
            all('.line[data-coverage="uncoverable"] .code')
          end

  lines.map! &:text

  # interate over the list and see if they match
  table.hashes.each do |row|
    lines.should have_line(row[:line])
  end
end

When /^I click "([^\"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should be on (.+)$/ do |path|
  current_path = URI.parse(current_url).path
  File.expand_path(current_path).should == File.expand_path(path)
end
