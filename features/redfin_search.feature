Feature: Redfin can search properties
  Perform a search with at least 3 filters

  Scenario: Perform search with 3 minimum filters
    Given I search for "97212"
    When I search with the following filters:
      | name   | value | min_max |
      | Baths  | 2+    | min     |
      | Price  | $800k | min     |
      | Beds   | 3     | min     |
    Then result set should match search criteria

  Scenario: Perform search with 3 maximum filters
    Given I search for "97215"
    When I search with the following filters:
      | name   | value | min_max |
      | Price  | $800k | max     |
      | Beds   | 2     | max     |
      | Sq.Ft. | 3,000 | max     |
    Then result set should match search criteria

  Scenario: Perform search with 3 ranged filters
    Given I search for "97215"
    When I search with the following filters:
      | name   | value | min_max |
      | Price  | $400k | min     |
      | Price  | $800k | max     |
      | Beds   | 1     | min     |
      | Beds   | 2     | max     |
      | Sq.Ft. | 2,000 | min     |
      | Sq.Ft. | 3,000 | max     |
    Then result set should match search criteria