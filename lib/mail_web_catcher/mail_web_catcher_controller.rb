# frozen_string_literal: true

module MailWebCatcher
  class MailboxController < ActionController::Base
    self.view_paths = File.expand_path('templates', __dir__)

    layout 'application'

    before_action :set_mails, only: %i[index]

    def index
      @part = find_preferred_part(request.format, Mime[:html], Mime[:text]) if @mail
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
        part = @mail.find_first_mime_type(format)
        return part if part
      end

      return unless formats.any? { |f| @mail.mime_type == f }

      @mail
    end

    def email_body
      @mail.part[1].body.decoded
    end

    def set_mails
      @mails = RailsCacheDeliveryMethod.mails
      @mail = @mails.detect { |m| m.message_id == params[:id] } if params[:id]
    end
  end
end
