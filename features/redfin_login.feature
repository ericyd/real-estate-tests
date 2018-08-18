Feature: Capybara second
  test scenario for Capybara

  Scenario Outline: What does Capybara do
    Given email is <email> and password is <password>
    When I sign in
    Then the name badge should be <visibility>
    And <name> should display in the menu

  Examples:
    | email | password | visibility | name |
    | "acornsTestAccount@guerrillamail.com" | "Acornstest1000" | "visible" | "Eric" |
    | "anotheremail@anotherdomain.com" | "Acornstest100" | "hidden" | "" |
    | "anythingelse" | "anythingelse" | "hidden" | "" |
