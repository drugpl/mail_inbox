module MailInbox

  class DeliveryNotFound < StandardError; end

  class Inbox

    attr_reader :deliveries

    def initialize(deliveries)
      @deliveries = deliveries
    end

    def recipients
      deliveries.collect { |delivery| delivery.to }.flatten.sort
    end

    def for(recipient)
      deliveries.select { |delivery| delivery.to.include?(recipient) }
    end

    def get(id)
      identifier = id.to_i
      deliveries.detect { |delivery| delivery.object_id == identifier } || raise(DeliveryNotFound)
    end

    def all
      deliveries.sort_by(&:subject)
    end

  end
end
