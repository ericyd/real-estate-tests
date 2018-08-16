module CapybaraStepHelper
  def is_capybara_invoked?(status)
    if status == 'yes'
      'yep'
    else
      'no way'
    end
  end
end
World CapybaraStepHelper

Given("capybara is invoked") do
  @invoked = 'yes'
end

Given("capybara is not invoked") do
  @invoked = 'no'
end

When("I try to log in") do
  @actual_answer = is_capybara_invoked?(@invoked)
end

Then("I should get a {string}") do |expected_answer|
  expect(@actual_answer).to eq(expected_answer)
end