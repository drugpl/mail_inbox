module MailInbox
  class Mailer

    attr_accessor :settings

    def initialize(*)
      @settings = {}
    end

    def deliver!(mail)
      ActionMailer::Base.deliveries << mail
    end

    def self.deliveries
      ActionMailer::Base.deliveries
    end

    def self.clear_deliveries!
      ActionMailer::Base.deliveries.clear
    end
  end

end
