Dummy::Application.routes.draw do
  mount MailInbox::Application.new, :at => "/mails"
end
