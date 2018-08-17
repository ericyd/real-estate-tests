Feature: Capybara second
  test scenario for Capybara

  Scenario Outline: What does Capybara do
    Given email is <email> and password is <password>
    When I sign in
    Then <name> should display in the menu

  Examples:
    | email | password | name |
    | "acornsTestAccount@guerrillamail.com" | "Acornstest1000" | "Eric" |
    | "anotheremail@anotherdomain.com" | "Acornstest100" | "" |
    | "anythingelse" | "anythingelse" | "" |
