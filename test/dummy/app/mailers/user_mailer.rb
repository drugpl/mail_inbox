class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome
    @greeting = "Hi"
    mail :to => "rec@example.com", :subject => "Getting started"
  end
end
