require 'capybara'
require 'capybara/cucumber'
require_relative '../pages/redfin_homepage'

Capybara.default_driver = :selenium_chrome_headless #:selenium_chrome, :selenium_chrome_headless

Capybara.configure do |config|
  config.run_server = false
  config.app_host   = 'http://www.redfin.com'
end

Before do
  @redfin_home = RedfinHomepage.new
end

Given("email is {string} and password is {string}") do |email, password|
  @email = email
  @password = password
  visit('/')
  @redfin_home.resize_full
  # should test both the dropdown signin and this signin...y'know, for thoroughness
  # visit('https://www.redfin.com/stingray/do/login')
end

When("I sign in") do
  @redfin_home.sign_in @email, @password
  @name_badge_visibility, @name = @redfin_home.check_login_status
end

Then("{string} should display in the menu") do |name|
  expect(@name).to eq(name)
end

Then("the name badge should be {string}") do |visibility|
  expect(@name_badge_visibility).to eq(visibility)
end
