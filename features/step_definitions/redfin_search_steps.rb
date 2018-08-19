require 'capybara'
require 'capybara/cucumber'

# Options - :selenium_chrome, :selenium_chrome_headless
Capybara.default_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = 5

Capybara.configure do |config|
  config.run_server = false
  config.app_host   = 'http://www.redfin.com'
end

Before do
  @redfin_search = RedfinSearch.new
end

Given('I search for {string}') do |zipcode|
  @zipcode = zipcode
  visit('/')
  # window must be full size for correct data table columns to display
  @redfin_search.resize_full
  @redfin_search.search_for @zipcode
end

When('I search with the following filters:') do |table|
  @filters = table.hashes

  @redfin_search.apply_filters @filters
  @redfin_search.toggle_display_mode :table
end

Then('result set should match search criteria') do
  # Verify property values meet the filter criteria
  results = @redfin_search.map_filters_to_results @filters
  results.each do |values|
    values.each do |value|
      if value['comparison'] == 'min'
        expect(value['actual']).to be >= (value['expected'])
      else
        expect(value['actual']).to be <= (value['expected'])
      end
    end
  end

  # Verify property is in correct zip code
  @redfin_search.zipcodes.each do |zipcode|
    expect(zipcode).to match(Regexp.new(@zipcode)),
                       "expected address '#{zipcode}'
                       to contain zipcode '#{@zipcode}'"
  end
end
