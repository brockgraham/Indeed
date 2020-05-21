require_relative 'page/functions'
require 'inifile'

class IndeedResponder
  @indeed = Indeed.new
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

    # @wait.until { @driver.find_element(id: "plugin-hadesinternal-HanselCondensedJobListModal-modal_close_button") }
    # x_popup = @driver.find_element(id: "plugin-hadesinternal-HanselCondensedJobListModal-modal_close_button")
    # x_popup.click

    @indeed.click_object(@indeed.elements[:candidates])
    @indeed.click_object(@indeed.elements[:awaiting_review])
  end

  def self.send_message_to_person
    @indeed.click_object(@indeed.elements[:first_person])
    @indeed.click_object(@indeed.elements[:check_mark])
    @indeed.click_object(@indeed.elements[:message_button])
    sleep 2
    @indeed.click_object(@indeed.elements[:dropdown])
    @indeed.click_object(@indeed.elements[:dp_option])
    sleep 1

    # send_message_button = @driver.find_element(css: "button[class*='sendButton']")
    # send_message_button.location_once_scrolled_into_view
    # send_message_button.click
    sleep 1
  end

  def self.send_response_to_list
    10.times do
      candidates_list = @indeed.element(@indeed.elements[:candidates_list])
      counter = 2

      candidates_list.each do
        @indeed.dynamic_click("#hanselCandidateListContainer > div > div.HanselCandidateList-list-container", 'div', counter)
        begin
          @indeed.scroll_into_view(@indeed.elements[:check_mark])
          @indeed.click_object(@indeed.elements[:check_mark])
        rescue
          sleep 2
          @indeed.click_object(@indeed.elements[:check_mark])
        end
        @indeed.click_object(@indeed.elements[:message_button])
        @indeed.click_object(@indeed.elements[:dropdown])
        @indeed.click_object(@indeed.elements[:dp_option])
        sleep 1

        # send_message_button = @driver.find_element(css: "button[class*='sendButton']")
        # send_message_button.location_once_scrolled_into_view
        # sleep 1
        # send_message_button.click

        counter += 1
        puts 'One Complete!'
        sleep 1
      end
      @indeed.click_object(@indeed.elements[:back_awaiting])
      puts 'Twenty Sent'
      send_message_to_person
    end
  end

  sign_in
  navigate_to_people
  send_message_to_person
  send_response_to_list
end

