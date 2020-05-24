class Elements
  attr_accessor :elements

  def initialize
    @elements = {
        :pop_up => '#plugin-hadesinternal-HanselCondensedJobListModal-modal_close_button',
        :email => '#login-email-input',
        :password => '#login-password-input',
        :sign_in => '#login-submit-button',
        :candidates => "a[href='/c#candidates']",
        :awaiting_review => "div[class='cpqap-CandidateStatus-Tab']",
        :first_person => "a[data-tn-element='view-candidate']",
        :check_mark => "span[class='ecl-sentiment-selector-3fVU4 ecl-sentiment-selector-3E4_p']",
        :message_button => '#topComposeEmailButton',
        :dropdown => '#previewComponent',
        :dp_option => "#previewComponent > option:nth-child(2)",
        :send_message => "button[class$='sendButton']",
        :next => '#nextPreBlock-next',
        :disabled_next => '#nextPreBlock-next[disabled]',
        :candidates_list => "h3[class='CandidateListItem-name CandidateListItem-text']",
        :back_awaiting => '#statusFilterDescription'
    }
  end

end
