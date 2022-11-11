# frozen_string_literal: true

module MailWebCatcher
  class MailWebCatcherController < ActionController::Base
    self.view_paths = File.expand_path('templates', __dir__)

    layout 'application'

    def index
      @emails = RailsCacheDeliveryMethod.mails
      @email = @emails[params[:index].to_i]
      @part = find_preferred_part(request.format, Mime[:html], Mime[:text]) if @email
      return unless params[:part]

      response.content_type = 'text/html'
      render plain: email_body
    end

    def clear
      RailsCacheDeliveryMethod.clear
      redirect_to '/mails'
    end

    private

    def find_preferred_part(*formats)
      formats.each do |format|
        part = @email.find_first_mime_type(format)
        return part if part
      end

      return unless formats.any? { |f| @email.mime_type == f }

      @email
    end

    def email_body
      @email.part[1].body.decoded
    end
  end
end
