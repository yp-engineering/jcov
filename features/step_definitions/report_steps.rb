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
    regex = Regexp.new(Regexp.escape(row[:line]))
    lines.any? {|line| line =~ regex}.should be_true("didn't find \"#{row[:line]}\" in the list of #{type} lines")
  end
end

When /^I click "([^\"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should be on (.+)$/ do |path|
  current_path = URI.parse(current_url).path
  File.expand_path(current_path).should == File.expand_path(path)
end
