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

