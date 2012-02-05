require 'test_helper'

class MailTest < Bbq::TestCase

  setup do
    @user = Bbq::TestUser.new
  end

  teardown do
    MailInbox::Mailer.clear_deliveries!
  end

  scenario "user sees received emails" do
    mail = get_mail(:subject => "Getting started")
    deliver_mail(mail)
    @user.visit "/mails"
    @user.see! mail.subject
  end

  scenario "user sees all recipients" do
    mails = [
              get_mail(:to => "alice@example.com"),
              get_mail(:to => "bob@example.com"),
              get_mail(:to => "claire@example.com")
            ]
    mails.each { |mail| deliver_mail(mail) }

    @user.visit "/mails"
    @user.within '.recipients' do
      mails.each { |mail| @user.see!(mail.to) }
    end
  end

  scenario "user sees all subjects" do
    mails = [
              get_mail(:subject => "hi there"),
              get_mail(:subject => "hello world"),
              get_mail(:subject => "i'm just a horse")
            ]
    mails.each { |mail| deliver_mail(mail) }

    @user.visit "/mails"
    @user.within '.mails' do
      mails.each { |mail| @user.see!(mail.subject) }
    end
  end

  scenario "user sees mail details" do
    mail = get_mail(:from => "alice@example.net", :to => "bob@example.net", :subject => "hi there", :body => "what's up bro?")
    deliver_mail(mail)

    @user.visit "/mails"
    @user.click_on mail.subject
    @user.see! mail.from
    @user.see! mail.to
    @user.see! mail.subject
    @user.see! mail.body
  end

  scenario "user browses emails by recipient" do
    mails = [
              get_mail(:to => "alice@example.net", :subject => "let's introduce aspects"),
              get_mail(:to => "bob@example.net", :subject => "cool story bro"),
              get_mail(:to => "bob@example.net", :subject => "are you insane?")
            ]
    mails.each { |mail| deliver_mail(mail) }

    @user.visit "/mails"
    @user.click_on "alice@example.net"
    @user.see! "let's introduce aspects"
    @user.not_see! "cool story bro"
    @user.not_see! "are you mad?"

    @user.click_on "bob@example.net"
    @user.not_see! "let's introduce aspects"
    @user.see! "cool story bro"
    @user.see! "are you insane?"
  end

  def get_mail(options = {})
    OpenStruct.new(mail_defaults.merge(options))
  end

  def deliver_mail(mail)
    UserMailer.welcome(mail).deliver
  end

  def mail_defaults
    {
      :from     => "alice@example.com",
      :to       => "bob@example.com",
      :subject  => "hello there"
    }
  end

end
