# Page Object for Redfin Homepage
class RedfinHomepage < Redfin
  def sign_in_from(location = :home, email = '', password = '')
    if location == :home
      sign_in_from_home email, password
    else
      sign_in_from_secondary email, password
    end
  end

  def sign_in_from_home(email = '', password = '')
    visit('/')
    click_button 'Log In'

    within('.signInForm') do
      click_button 'Continue with Email'
    end

    within('.SignInEmailForm') do
      fill_in 'emailInput', with: email
      fill_in 'passwordInput', with: password
    end

    click_button 'Sign In'
  end

  def sign_in_from_secondary(email = '', password = '')
    visit('/stingray/do/login')
    fill_in 'email_input', with: email
    fill_in 'password_input', with: password
    # this page has a somewhat non-semantic structure;
    # submitting form by pressing `enter` is easiest
    find('[name="password_input"').send_keys :enter
  end

  def check_login_status
    begin
      name_container = find('.NameAndThumbnail')
      name = name_container.find('.name').text
      name_badge_visibility = 'visible'
    rescue Capybara::ElementNotFound
      name = ''
      name_badge_visibility = 'hidden'
    end
    [name_badge_visibility, name]
  end
end
