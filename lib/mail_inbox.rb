require 'mail_inbox/version'
require 'mail_inbox/application'
require 'mail_inbox/mapper'
require 'mail_inbox/mailer'
require 'rack/mime'
require 'pathname'
require 'erb'
require 'tilt'

module MailInbox
  class << self
    def root
      Pathname.new(File.expand_path('../', __FILE__))
    end

    def default_email_template_path
      root.join('templates', 'email.html.erb')
    end

    def default_index_template_path
      root.join('templates', 'index.html.erb')
    end

    def default_index_template
      Tilt.new(default_index_template_path)
    end

    def default_email_template
      Tilt.new(default_email_template_path)
    end
  end
end
