module MailInbox
  class Application
    def call(env)
      @script_name = env['SCRIPT_NAME']
      case env['PATH_INFO']
      when '', '/'
        response_ok render_index(inbox.all)
      when %r{^/mails/([\w_]+)(\.\w+)?}
        id     = $1
        format = $2 || ".html"

        begin
          mail = inbox.get(id)
          response_ok render_mail(id, mail, format)
        rescue MailInbox::DeliveryNotFound
          response_not_found
        end
      when %r{^/recipients/(.*)$}
        recipient = $1

        mails = inbox.for(recipient)
        response_ok render_index(mails)
      else
        response_not_found :pass => true
      end
    end

    protected
    def inbox
      @inbox ||= MailInbox::Inbox.new(MailInbox::Mailer.deliveries)
    end

    def default_headers
      {'Content-Type' => 'text/html'}
    end

    def response_ok(body)
      [200, default_headers, [body]]
    end

    def response_not_found(options = {})
      headers               = default_headers
      headers['X-Cascade']  = 'pass' if options[:pass]
      [404, headers, ['Not Found']]
    end

    def render_index(mails)
      mails      = mails.collect { |mail| [mail.subject, mail_path(mail.object_id)] }
      recipients = inbox.recipients.collect { |recipient| [recipient, recipient_path(recipient)] }
      MailInbox.default_index_template.render(self, :mails => mails, :recipients => recipients)
    end

    def render_mail(name, mail, format = nil)
      body_part = mail

      if mail.multipart?
        content_type = Rack::Mime.mime_type(format)
        body_part = mail.parts.find { |part| part.content_type.match(content_type) } || mail.parts.first
      end

      MailInbox.default_email_template.render(self, :name => name, :mail => mail, :body_part => body_part)
    end

    def mail_path(mail_id)
      path_for(:mails, mail_id)
    end

    def recipient_path(recipient_id)
      path_for(:recipients, recipient_id)
    end

    def path_for(*parts)
      ([@script_name] + parts).collect(&:to_s).join("/")
    end

  end
end
