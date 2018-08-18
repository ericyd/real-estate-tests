require 'capybara'
require 'capybara/cucumber'

Capybara.default_driver = :selenium_chrome_headless

Capybara.configure do |config|
  config.run_server = false
  config.app_host   = 'http://www.redfin.com'
end

Given("email is {string} and password is {string}") do |email, password|
  @email = email
  @password = password
  visit('/')
  # should test both the dropdown signin and this signin...y'know, for thoroughness
  # visit('https://www.redfin.com/stingray/do/login')
end

When("I sign in") do
  click_button "Log In"

  within(".signInForm") do
    click_button "Continue with Email"
  end

  within(".SignInEmailForm") do
    fill_in "emailInput", with: @email
    fill_in "passwordInput", with: @password
  end

  click_button 'Sign In'

  begin
    name_container = find(".NameAndThumbnail")
    @actual_name = name_container.find(".name").text
    @name_badge_visibility = "visible"
  rescue Capybara::ElementNotFound => exception
    @actual_name = ""
    @name_badge_visibility = "hidden"
  end
end

Then("{string} should display in the menu") do |name|
  expect(@actual_name).to eq(name)
end

Then("the name badge should be {string}") do |visibility|
  expect(@name_badge_visibility).to eq(visibility)
end
