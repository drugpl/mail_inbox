require 'test_helper'

class MailTest < Bbq::TestCase

  background do
    UserMailer.welcome.deliver
  end

  scenario "user sees received emails" do
    user = Bbq::TestUser.new
    user.visit "/mails"
    user.see! "Getting started"
  end

end
