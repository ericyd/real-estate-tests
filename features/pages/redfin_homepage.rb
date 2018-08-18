require_relative './redfin'

class RedfinHomepage < Redfin
  def sign_in(email = "", password = "")
    click_button "Log In"

    within(".signInForm") do
      click_button "Continue with Email"
    end

    within(".SignInEmailForm") do
      fill_in "emailInput", with: email
      fill_in "passwordInput", with: password
    end

    click_button 'Sign In'
  end

  def check_login_status()
    begin
      name_container = find(".NameAndThumbnail")
      name = name_container.find(".name").text
      name_badge_visibility = "visible"
    rescue Capybara::ElementNotFound => exception
      name = ""
      name_badge_visibility = "hidden"
    end
    [name_badge_visibility, name]
  end
end