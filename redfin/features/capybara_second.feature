Feature: Capybara second
  test scenario for Capybara

  Scenario Outline: What does Capybara do
    Given email is <email> and password is <password>
    When I try to log in
    Then I should see my name in the upper corner

  Examples:
    | email | password |
    | "acornsTestAccount@guerrillamail.com" | "Acornstest1000" |
    | "anotheremail@anotherdomain.com" | "Acornstest100" |
    | "anythingelse" | "anythingelse" |
