# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'

  layout false

  def welcome(to_address: 'to@example.com')
    mail(to: to_address, subject: 'Welcome to GravityMailbox')
  end
end
