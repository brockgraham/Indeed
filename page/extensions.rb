require 'selenium-webdriver'
require_relative 'elements'

class Extensions
  attr_accessor :driver
  attr_accessor :wait

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
    @elements = Elements.new.elements
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
    click(identifier)
  end

  def dynamic_click(identifier, tag, num)
    @wait.until { element("#{identifier} > #{tag}:nth-child(#{num})") }
    click(identifier)
  end

  def scroll_into_view(identifier)
    @wait.until { element(identifier) }
    element(identifier).location_once_scrolled_into_view
  end

  private

  def click(element)
    @driver.find_element(css: element).click
  end

end
