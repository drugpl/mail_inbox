module MailInbox
  class Application
    def call(env)
      @script_name = env['SCRIPT_NAME']
      case env['PATH_INFO']
      when '', '/'
        response_ok render_index
      when /([\w_]+)(\.\w+)?$/
        name   = $1
        format = $2 || ".html"

        if inbox[name]
          response_ok render_mail(name, inbox[name], format)
        else
          response_not_found
        end
      else
        response_not_found :pass => true
      end
    end

    protected
    def inbox
      Hash[MailInbox::Mailer.deliveries.collect { |mail| [mail.object_id.to_s, mail] }]
    end

    def path_from_name(name)
      "#{@script_name}/#{name}"
    end

    def default_headers
      {'Content-Type' => 'text/html'}
    end

    def response_ok(body)
      [200, default_headers, body]
    end

    def response_not_found(options = {})
      headers               = default_headers
      headers['X-Cascade']  = 'pass' if options[:pass]
      [404, headers, 'Not Found']
    end

    def render_index
      links = inbox.collect { |name, mail| [name, path_from_name(name)] }
      MailInbox.default_index_template.render(self, :links => links)
    end

    def render_mail(name, mail, format = nil)
      body_part = mail

      if mail.multipart?
        content_type = Rack::Mime.mime_type(format)
        body_part = mail.parts.find { |part| part.content_type.match(content_type) } || mail.parts.first
      end

      MailInbox.default_email_template.render(self, :name => name, :mail => mail, :body_part => body_part)
    end
  end
end
