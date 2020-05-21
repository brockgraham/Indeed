require 'selenium-webdriver'
require 'inifile'

class Indeed
  attr_accessor :driver
  attr_accessor :wait
  attr_accessor :elements

  def initialize
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    options.add_argument('--no-sandbox')
    # options.add_argument('--headless')

    @driver = Selenium::WebDriver.for :chrome, options: options
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    @driver.navigate.to 'https://secure.indeed.com/account/login?hl=en_US&co=US&continue=https%3A%2F%2Fwww.indeed.com%2F&tmpl=desktop&service=my&from=gnav-util-homepage&_ga=2.171712096.1797241527.1588699743-345046149.1588699743'
    @elements = {
        :email => '#login-email-input',
        :password => '#login-password-input',
        :sign_in => '#login-submit-button',
        :candidates => "a[href='/c#candidates']",
        :awaiting_review => "div[class='cpqap-CandidateStatus-Tab']",
        :first_person => "a[data-tn-element='view-candidate']",
        :check_mark => "span[class='ecl-sentiment-selector-3fVU4 ecl-sentiment-selector-3E4_p']",
        :message_button =>'#topComposeEmailButton',
        :dropdown => "span[class='TemplateTools-quickAction highlight']",
        :dp_option => "span[class='MessageActionItem-title']",
        :candidates_list => "h3[class='CandidateListItem-name CandidateListItem-text']",
        :back_awaiting => '#statusFilterDescription'
    }
  end

  def element(element)
    @driver.find_element(css: element)
  end

  def log_in(email, pass)
    @wait.until { element(@elements[:email]) }
    element(@elements[:email]).send_keys email
    element(@elements[:password]).send_keys pass
    element(@elements[:sign_in]).click
  end

  def click_object(identifier)
    @wait.until { element(identifier) }
    identifier.click
  end

  def dynamic_click(identifier, tag, num)
    @wait.until { element("#{identifier} > #{tag}:nth-child(#{num})") }
    identifier.click
  end

  def scroll_into_view(identifier)
    @wait.until { element(identifier) }
    identifier.location_once_scrolled_into_view
  end

end
