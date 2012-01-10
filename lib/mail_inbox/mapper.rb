module MailInbox
 class Mapper
    def initialize(app, prefix = "/mail_inbox")
      @app        = app
      @controller = MailInbox::Application.new
      @prefix     = Regexp.compile("^#{prefix}")
    end

    def call(env)
      if env["PATH_INFO"].to_s =~ @prefix
        env["SCRIPT_NAME"], env["PATH_INFO"] = $&, $'
        @controller.call(env)
      else
        @app.call(env)
      end
    end
  end
end
