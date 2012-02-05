class UserMailer < ActionMailer::Base
  def welcome(data)
   mail :from => data.from,
        :to => data.to,
        :subject => data.subject,
        :sender => data.sender
  end
end
