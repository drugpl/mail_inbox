module MailInbox
  class Mailer
    class << self
      def deliveries
        ActionMailer::Base.deliveries
      end

      def clear_deliveries!
        ActionMailer::Base.deliveries.clear
      end
    end

    module InstanceMethods
      def perform_delivery_mail_inbox(mail)
        ActionMailer::Base.deliveries << mail
      end
    end
  end
end

ActionMailer::Base.send(:include, MailInbox::Mailer::InstanceMethods)
