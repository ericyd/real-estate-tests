require 'capybara'
require 'capybara/cucumber'

module Pages
  class RedfinSearch
    include Capybara::DSL

    def add_filter(name, value)
      case name
      when 'Price'
        add_price_filter value
      when 'Baths'
        add_baths_filter value
      when 'Type'
        add_type_filter value
      when 'Beds'
        add_beds_filter value
      when 'Sq.Ft.'
        add_sqft_filter value
      else
        puts "Unable to apply filter '#{name}: #{value}'"
      end
    end
    
    def add_price_filter(value)
      within(".minPrice") do
        find(".input").click
        find(".flyout").find(".option", text: value).click
      end
    end

    def add_baths_filter(value)
      value_map = {
        "No min" => 0,
        "1+" => 1,
        "1.25+" => 2,
        "2+" => 3,
        "3+" => 4,
        "4+" => 5
      }
      within(".baths") do
        (1..value_map[value]).each do |i|
          find(".step-up").click
        end
      end
    end

    def add_beds_filter(value)
      within(".minBeds") do
        find(".input").click
        find(".flyout").find(".option", text: value).click
      end
    end

    def add_type_filter(value)
      within("#propertyTypeFilter") do
        click_button value
      end
    end

    def add_sqft_filter(value)
      
    end

  end
end
World Pages


def convert(value, type)
  case type
  when 'Price'
    # convert dollar-formatted text to float
    value.sub! "M", "000000"
    value.sub! "k", "000"
    value.gsub! /[$,]/, ""
    value.to_f
  # when 'Address'
  #   0
  else
    value.to_f
  end
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
  within("#homepageTabContainer") do
    fill_in "search-box-input", with: zipcode
    click_button "Search"
  end
  # force capybara to wait for search page to load
  within("#headerUnifiedSearch") do
    # puts page.title # => "97212, OR Real Estate & Homes for Sale | Redfin"
  end

  # window must be full size for correct data table columns to display
  page.windows.each do |window|
    window.resize_to 1920, 1080
  end
end

When("I search with the following minimum filters:") do |table|
  @filters = table.hashes # << { 'name' => 'zipcode', 'value' => @zipcode }
  find(".wideSidepaneFilterButton").click
  within("#searchForm") do
    @filters.each do |filter|
      @redfin.add_filter filter['name'], filter['value']
    end

    click_button "Apply Filters"
  end

  within(".displayModeToggler") do
    click_button "Table"
  end

  # force data table to load
  within(".ReactDataTable") do
    find("button", text: "Location")
  end
end

Then("nothing") do
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

    all(".tableRow").each do |result|
      @filters.each do |filter|
        prop = result.all('td')[columns[filter['name']]].text
        # puts "prop: #{filter['name']}, value: #{prop}, expected: #{filter['value']}, ok: #{filter['value'].to_f <= prop.to_f}"
        actual = convert(prop, filter['name'])
        expected = convert(filter['value'], filter['name'])
        # puts "actual: #{actual}, expected: #{expected}"
        expect(actual).to be >= (expected)
      end
    end
  end
end
