Feature: Capybara first
  test scenario for Capybara

  Scenario: What does Capybara do
    Given capybara is invoked
    When I try to log in
    Then I should get a "yep"

  Scenario: What does Capybara do again
    Given capybara is not invoked
    When I try to log in
    Then I should get a "no way"