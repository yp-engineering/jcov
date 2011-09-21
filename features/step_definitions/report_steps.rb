Given /^I open the report$/ do
  visit "/report.html"
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content text
end

Then /^I should see these values:$/ do |table|
  table.hashes.each do |attributes|
    page.should have_content attributes.join
  end
end

When /^I click "([^\"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should be on (.+)$/ do |path|
  current_path = URI.parse(current_url).path
  File.expand_path(current_path).should == File.expand_path(path)
end
