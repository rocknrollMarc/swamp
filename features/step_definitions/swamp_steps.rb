Given /^swamp is not yet running$/ do
end

When /^(?:I start it|that swamp is already running)$/ do
  swamp.run
end

Then /^I should see "(.*?)"$/ do |outcome|
  fake_output.messages.should include(outcome)
end

Given /^I enter the url for this page: "(\w+\.html)"$/ do |page|
  path = File.join(File.dirname(__FILE__), '../support/page_examples/', page)
  @url = "file://#{path}"
end

When /^swamp scans that page$/ do
  swamp.scan(@url)
end

When /^I attempt to scan this page: "(\w+\.html)"$/ do |page|
  path = File.join(File.dirname(__FILE__), '../support/page_examples/', page)
  url = "file://#{path}"
  swamp.scan(url)
end

Then /^(?:swamp|it) should output the following code snippets?$/ do |string|
  fake_output.messages.should include(string)
end

Then /^swamp should not output any snippet$/ do
  fake_output.messages.size.should <= 3
  fake_output.messages.each do |m|
    m.should_not include("def")
    m.should_not include("source.")
    m.should_not include("page.")
  end
end

Given /^that swamp already have scanned a page$/ do
  swamp.run
  path = File.join(File.dirname(__FILE__), '../support/page_examples/', "button.html")
  @url = "file://#{path}"
  swamp.scan(@url)
  fake_output.messages.should include("def sign_up\n  page.click_button(\"Sign Up\")\nend")
end

When /^I attempt to hit enter at the terminal$/ do
  swamp.scan("\n")
end

Then /^swamp should scan the current page$/ do
  fake_output.messages.size.should <= 5
  fake_output.messages[3].should == "Scanning, please wait..."
  fake_output.messages[4].should == "def sign_up\n  page.click_button(\"Sign Up\")\nend"
end

Then /^swamp should highlight this (element|link): "(.+)"$/ do |mode, selector|
  page = Capybara.current_session
  page.should have_css "#{selector}[style]"
  if mode == "element"
    page.find(selector)[:style].should include("border-width: 3px")
    page.find(selector)[:style].should include("border-color: rgb(255, 0, 0)")
  else
    page.find(selector)[:style].should include("background-color: rgb(255, 0, 0)")
  end
end

When /^I attempt to execute the command "(.*?)"$/ do |command|
  swamp.setup_command(command)
end

Given(/^its using "(.*?)" scope$/) do |scope|
  swamp.setup_command(":scope = #{scope}")
end

When(/^swamp scan this page: "(.*?)"$/) do |page|
  path = File.join(File.dirname(__FILE__), '../support/page_examples/', page)
  @url = "file://#{path}"
  swamp.scan(@url)
end
