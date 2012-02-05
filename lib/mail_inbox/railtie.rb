module MailInbox
  class Railtie < Rails::Railtie

    initializer "mail_inbox.add_delivery_method" do |app|
      ActionMailer::Base.add_delivery_method :mail_inbox, ::MailInbox::Mailer
    end

  end
end
