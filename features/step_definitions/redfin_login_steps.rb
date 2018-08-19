require 'capybara'
require 'capybara/cucumber'

# Options - :selenium_chrome, :selenium_chrome_headless
Capybara.default_driver = :selenium_chrome_headless

Capybara.configure do |config|
  config.run_server = false
  config.app_host   = 'http://www.redfin.com'
end

Before do
  @redfin_home = RedfinHomepage.new
end

Given('email is {string} and password is {string}') do |email, password|
  @email = email
  @password = password
end

When('I sign in from home') do
  visit('/')
  @redfin_home.resize_full
  @redfin_home.sign_in_from_home @email, @password
  @name_badge_visibility, @name = @redfin_home.check_login_status
end

When('I sign in from secondary') do
  visit('/stingray/do/login')
  @redfin_home.resize_full
  @redfin_home.sign_in_from_secondary @email, @password
  @name_badge_visibility, @name = @redfin_home.check_login_status
end

Then('{string} should display in the menu') do |name|
  expect(@name).to eq(name)
end

Then('the name badge should be {string}') do |visibility|
  expect(@name_badge_visibility).to eq(visibility)
end
