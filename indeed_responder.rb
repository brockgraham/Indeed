require_relative 'page/extensions'
require_relative 'page/elements'
require 'inifile'

class IndeedResponder < Extensions
  @indeed = Extensions.new
  @elements = Elements.new.elements
  @file = IniFile.load('./config.ini')
  @employer_link = 'https://employers.indeed.com/j#jobs'

  def self.sign_in
    username = @file['LOGIN']['username']
    pass = @file['LOGIN']['password']

    @indeed.log_in(username, pass)
    sleep 1
  end

  def self.navigate_to_people
    @indeed.driver.navigate.to @employer_link
    @indeed.click_object(@elements[:candidates])
    @indeed.click_object(@elements[:awaiting_review])
    @indeed.click_object(@elements[:first_person])
  end

  def self.respond
    while true do
      @indeed.click_object(@elements[:check_mark])
      @indeed.click_object(@elements[:message_button])
      sleep 2
      @indeed.click_object(@elements[:dropdown])
      @indeed.click_object(@elements[:dp_option])
      sleep 1
      @indeed.scroll_into_view(@elements[:send_message])
      @indeed.click_object(@elements[:send_message])
      sleep 1
      @indeed.scroll_into_view(@elements[:next])
      @indeed.click_object(@elements[:next])
    end
  end

  sign_in
  navigate_to_people
  respond
end

