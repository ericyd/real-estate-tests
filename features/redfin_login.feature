Feature: Redfin can log in
  Check logging in with valid and invalid credentials

  Scenario Outline: Log in to Redin.com
    Given email is <email> and password is <password>
    When I sign in
    Then the name badge should be <visibility>
    And <name> should display in the menu

  Examples:
    | email | password | visibility | name |
    | "acornsTestAccount@guerrillamail.com" | "Acornstest1000" | "visible" | "Eric" |
    | "wrong_email_addr@guerrillamail.com" | "Acornstest1000" | "hidden" | "" |
    | "acornsTestAccount@guerrillamail.com" | "wrong_password" | "hidden" | "" |
    | "another_email@anotherdomain.com" | "another_password" | "hidden" | "" |
