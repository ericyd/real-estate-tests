require 'capybara/dsl'

class Redfin
  include Capybara::DSL

  def resize_full()
    page.windows.each do |window|
      window.resize_to 1920, 1080
    end
  end
end