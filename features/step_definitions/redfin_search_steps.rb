require 'capybara'
require 'capybara/cucumber'

module Pages
  class RedfinSearch
    include Capybara::DSL

    def add_filter(name, value, min_max)
      case name
      when 'Price'
        add_price_filter value, min_max
      when 'Baths'
        # baths is always "at least" - no mix_max required
        add_baths_filter value
      when 'Type'
        # type is incompatible with min_max
        add_type_filter value
      when 'Beds'
        add_beds_filter value, min_max
      when 'Sq.Ft.'
        add_sqft_filter value, min_max
      else
        puts "Unable to apply filter '#{name}: #{value}'"
      end
    end

    def select_from_flyout(class_name, value)
      within(class_name) do
        find(".input").click
        find(".flyout").find(".option", text: value).click
      end
    end
    
    def add_price_filter(value, min_max)
      select_from_flyout ".#{min_max}Price", value
    end

    def add_baths_filter(value)
      # baths has slightly different markup, need to target a nested `.input`
      select_from_flyout ".baths > .input", value
    end

    def add_beds_filter(value, min_max)
      select_from_flyout ".#{min_max}Beds", value
    end

    def add_type_filter(value)
      within("#propertyTypeFilter") do
        click_button value
      end
    end

    def add_sqft_filter(value, min_max)
      select_from_flyout ".sqft#{min_max.capitalize}", value
    end

  end
end
World Pages


def to_number(value, type)
  if (type == "Price")
    # convert dollar-formatted text to float
    value.sub! "M", "000000"
    value.sub! "k", "000"
  end
  value.gsub! /[$,]/, ""
  value.to_f
end


Capybara.default_driver = :selenium_chrome_headless #:selenium_chrome, :selenium_chrome_headless
Capybara.default_max_wait_time = 5

Capybara.configure do |config|
  config.run_server = false
  config.app_host   = 'http://www.redfin.com'
end


Before do
  @redfin = Pages::RedfinSearch.new
end

Given("I search for {string}") do |zipcode|
  @zipcode = zipcode
  visit('/')
  # window must be full size for correct data table columns to display
  page.windows.each do |window|
    window.resize_to 1920, 1080
  end
  within("#homepageTabContainer") do
    fill_in "search-box-input", with: zipcode
    click_button "Search"
  end

  # force capybara to wait for search page to load
  find("#headerUnifiedSearch")
end

When("I search with the following filters:") do |table|
  @filters = table.hashes

  # open filter form
  find(".wideSidepaneFilterButton").click

  # apply filters
  within("#searchForm") do
    @filters.each do |filter|
      @redfin.add_filter filter['name'], filter['value'], filter['min_max']
    end

    click_button "Apply Filters"
  end

  # switch to table view
  within(".displayModeToggler") do
    click_button "Table"
  end
end

Then("result set should match search criteria") do
  within(".ReactDataTable") do
    # map columns for easy comparisons in the table rows
    # default to 0 so a valid column index is always returned
    columns = Hash.new(0)
    within("#tableView-table-header") do
      all("th button").each_with_index do |header, idx|
        if (header.text != "")
          columns[header.text] = idx
        end
      end
    end

    # Verify property values meet the filter criteria
    all(".tableRow").each do |result|
      @filters.each do |filter|
        prop = result.all('td')[columns[filter['name']]].text
        actual = to_number prop, filter['name']
        expected = to_number filter['value'], filter['name']
        if (filter['min_max'] == 'min')
          expect(actual).to be >= (expected)
        else
          expect(actual).to be <= (expected)
        end
      end

    end
    
    # Verify property is in correct zip code
    all(".HomeCardContainer").each do |card|
      city_state_zip = card.find(".cityStateZip").text
      expect(city_state_zip).to match(Regexp.new(@zipcode)), "expected address '#{city_state_zip}' to contain zipcode #{@zipcode}"
    end
  end
end
