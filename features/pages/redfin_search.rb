require 'capybara/dsl'

class RedfinSearch
  include Capybara::DSL

  def resize_full()
    page.windows.each do |window|
      window.resize_to 1920, 1080
    end
  end

  def search_for(term)
    within("#homepageTabContainer") do
      fill_in "search-box-input", with: term
      click_button "Search"
    end

    # force capybara to wait for search page to load
    find("#headerUnifiedSearch")
  end

  def open_filters_form()
    find(".wideSidepaneFilterButton").click
  end

  def apply_filters(filters)
    open_filters_form

    within("#searchForm") do
      filters.each do |filter|
        apply_filter filter['name'], filter['value'], filter['min_max']
      end

      click_button "Apply Filters"
    end
  end

  def toggle_display_mode(mode = :table)
    within(".displayModeToggler") do
      if (mode == :table)
        click_button "Table"
      else
        click_button "Photos"
      end
    end
  end

  def apply_filter(name, value, min_max)
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

  def get_zipcodes()
    within(".ReactDataTable") do
      all(".HomeCardContainer").map do |card|
        card.find(".cityStateZip").text
      end
    end
  end

  # convert text float, removing possible dollar-formatted
  def to_number(value, type)
    if (type == "Price")
      value.sub! "M", "000000"
      value.sub! "k", "000"
    end
    value.gsub! /[$,]/, ""
    value.to_f
  end

  # get headers from data table
  def get_column_headers()
    columns = Hash.new(0)
    within(".ReactDataTable") do
      within("#tableView-table-header") do
        all("th button").each_with_index do |header, idx|
          if (header.text != "")
            columns[header.text] = idx
          end
        end
      end
    end
    columns
  end

  # map rows to collections of filters
  # each filter collection contains the actual and expected value
  def map_filters_to_results(filters)
    # map columns for easy comparisons in the table rows
    # default to 0 so a valid column index is always returned
    columns = get_column_headers
    within(".ReactDataTable") do  
      all(".tableRow").map do |result|
        filters.map do |filter|
          prop = result.all('td')[columns[filter['name']]].text
          actual = to_number prop, filter['name']
          expected = to_number filter['value'], filter['name']
          {
            'actual' => actual,
            'expected' => expected,
            'comparison' => filter['min_max']
          }
        end
      end
    end
  end
end