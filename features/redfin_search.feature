Feature: Redfin can search properties
  Perform a search with at least 3 filters

  Scenario: Perform search with at least 3 filters
    Given I search for "97212"
    When I search with the following minimum filters:
      | name   | value |
      | Baths  | 2+    |
      | Price  | $800k |
      | Beds   | 3     |
    Then nothing