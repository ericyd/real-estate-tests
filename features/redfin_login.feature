Feature: Redfin can log in
  Check logging in with valid and invalid credentials

  Scenario Outline: Log in to Redin.com
    Given email is <email> and password is <password>
    When I sign in from <location>
    Then the name badge should be <visibility>
    And <name> should display in the menu

  Examples:
    | email                                 | password           | visibility | name   | location  |
    | "acornsTestAccount@guerrillamail.com" | "Acornstest1000"   | "visible"  | "Eric" | home      |
    | "wrong_email_addr@guerrillamail.com"  | "Acornstest1000"   | "hidden"   | ""     | home      |
    | "acornsTestAccount@guerrillamail.com" | "wrong_password"   | "hidden"   | ""     | home      |
    | "another_email@anotherdomain.com"     | "another_password" | "hidden"   | ""     | home      |
    | "acornsTestAccount@guerrillamail.com" | "Acornstest1000"   | "visible"  | "Eric" | secondary |
    | "wrong_email_addr@guerrillamail.com"  | "Acornstest1000"   | "hidden"   | ""     | secondary |
