require "selenium-webdriver"
require 'inifile'

class IndeedResponder

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-translate')
  options.add_argument('--no-sandbox')
  # options.add_argument('--headless')

  @file = IniFile.load('./config.ini')
  @driver = Selenium::WebDriver.for :chrome, options: options
  @wait = Selenium::WebDriver::Wait.new(timeout: 10)
  @employer_link = 'https://employers.indeed.com/j#jobs'

  @driver.navigate.to 'https://secure.indeed.com/account/login?hl=en_US&co=US&continue=https%3A%2F%2Fwww.indeed.com%2F&tmpl=desktop&service=my&from=gnav-util-homepage&_ga=2.171712096.1797241527.1588699743-345046149.1588699743'

  def self.sign_in
    email = @driver.find_element(id: 'login-email-input')
    password = @driver.find_element(id: 'login-password-input')
    sign_in = @driver.find_element(id: 'login-submit-button')
    username = @file['LOGIN']['username']
    pass = @file['LOGIN']['password']

    email.send_keys username
    password.send_keys pass
    sign_in.click
    sleep 1
  end

  def self.navigate_to_people
    @driver.navigate.to @employer_link

    # @wait.until { @driver.find_element(id: "plugin-hadesinternal-HanselCondensedJobListModal-modal_close_button") }
    # x_popup = @driver.find_element(id: "plugin-hadesinternal-HanselCondensedJobListModal-modal_close_button")
    # x_popup.click

    @wait.until { @driver.find_element(css: "a[href='/c#candidates']") }
    candidates = @driver.find_element(css: "a[href='/c#candidates']")
    candidates.click

    @wait.until { @driver.find_element(css: "div[class='cpqap-CandidateStatus-Tab']") }
    awaiting_review = @driver.find_element(css: "div[class='cpqap-CandidateStatus-Tab']")
    awaiting_review.click
  end

  def self.send_message_to_person
    @wait.until { @driver.find_element(css: "a[data-tn-element='view-candidate']") }
    first_person = @driver.find_element(css: "a[data-tn-element='view-candidate']")
    first_person.click

    @wait.until { @driver.find_element(css: "span[class='ecl-sentiment-selector-3fVU4 ecl-sentiment-selector-3E4_p']") }
    check_mark = @driver.find_element(css: "span[class='ecl-sentiment-selector-3fVU4 ecl-sentiment-selector-3E4_p']")
    check_mark.click


    @wait.until { @driver.find_element(id: 'topComposeEmailButton') }
    message_button = @driver.find_element(id: 'topComposeEmailButton')
    message_button.click

    sleep 2

    @wait.until { @driver.find_element(css: "span[class='TemplateTools-quickAction highlight']") }
    template_dropdown = @driver.find_element(css: "span[class='TemplateTools-quickAction highlight']")
    template_dropdown.click

    @wait.until { @driver.find_element(css: "span[class='MessageActionItem-title']") }
    template_option = @driver.find_element(css: "span[class='MessageActionItem-title']")
    template_option.click
    sleep 1

    # send_message_button = @driver.find_element(css: "button[class*='sendButton']")
    # send_message_button.location_once_scrolled_into_view
    # send_message_button.click
    sleep 1
  end

  def self.send_response_to_list
    10.times do
      @wait.until { @driver.find_element(css: "h3[class='CandidateListItem-name CandidateListItem-text']") }
      candidates_list = @driver.find_elements(css: "h3[class='CandidateListItem-name CandidateListItem-text']")
      counter = 2

      candidates_list.each do
        @driver.find_element(css: "#hanselCandidateListContainer > div > div.HanselCandidateList-list-container > div:nth-child(#{counter})").click

        @wait.until { @driver.find_element(css: "span[class='ecl-sentiment-selector-3kN6Y'] > span:nth-child(1)") }
        check_mark = @driver.find_element(css: "span[class='ecl-sentiment-selector-3kN6Y'] > span:nth-child(1)")
        check_mark.location_once_scrolled_into_view
        begin
          check_mark.click
        rescue

          sleep 2

          check_mark.click
        end


        @wait.until { @driver.find_element(id: 'topComposeEmailButton') }
        message_button = @driver.find_element(id: 'topComposeEmailButton')
        message_button.click


        @wait.until { @driver.find_element(css: "span[class='TemplateTools-quickAction highlight']") }
        template_dropdown = @driver.find_element(css: "span[class='TemplateTools-quickAction highlight']")
        template_dropdown.click

        @wait.until { @driver.find_element(css: "span[class='MessageActionItem-title']") }
        template_option = @driver.find_element(css: "span[class='MessageActionItem-title']")
        template_option.click
        sleep 1

        # send_message_button = @driver.find_element(css: "button[class*='sendButton']")
        # send_message_button.location_once_scrolled_into_view
        # sleep 1
        # send_message_button.click

        counter += 1
        puts 'One Fucker Complete!'
        sleep 1
      end

      back_to_awaiting = @driver.find_element(id: 'statusFilterDescription')
      back_to_awaiting.click

      puts 'Twenty Bitches Fucked'
      send_message_to_person
    end
  end

  sign_in
  navigate_to_people
  send_message_to_person
  send_response_to_list
end

