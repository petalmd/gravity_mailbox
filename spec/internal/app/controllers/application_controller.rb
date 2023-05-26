# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index; end

  def send_mail
    ApplicationMailer.welcome.deliver_now
    redirect_to root_path
  end
end
