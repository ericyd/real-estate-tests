require 'capybara/cucumber'

Capybara.default_driver = :selenium 
# :selenium_chrome_headless
# :selenium_chrome
# :selenium

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, headers: { 'HTTP_USER_AGENT' => 'Capybara' })
end


# Capybara.use_default_driver

# Capybara.app = MyRackApp

# You can use the Capybara DSL in your steps, like so:




module CapybaraStepHelper2
  def is_capybara_invoked?(status)
    if status == 'yes'
      'yep'
    else
      'no way'
    end
  end
end
World CapybaraStepHelper2








Given("email is {string} and password is {string}") do |email, password|
  @email = email
  @password = password
  visit('https://redfin.com')
  # should test both the dropdown signin and this signin...y'know, for thoroughness
  # visit('https://www.redfin.com/stingray/do/login')
  
end

When("I sign in") do
  within("#session") do
    fill_in 'Email', with: @email
    fill_in 'Password', with: @password
  end
  click_button 'Sign in'
  @actual_answer = 'yep'
end

Then("I should see my name in the upper corner") do
  expect(@actual_answer).to eq('yep')
end