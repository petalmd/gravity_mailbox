# frozen_string_literal: true

require 'action_controller'

module GravityMailbox
  class MailboxController < ActionController::Base
    self.view_paths = File.expand_path('templates', __dir__)

    layout 'application'

    before_action :set_mails, only: %i[index]

    def index
      @part = find_preferred_part(*[request.format, Mime[:html], Mime[:text]].uniq) if @mail
      return unless params[:part]

      response.content_type = 'text/html'
      render plain: @part&.decoded
    end

    def download_eml
      @mail = RailsCacheDeliveryMethod.mail(params[:id])
      send_data @mail.to_s, filename: "#{@mail.subject}.eml"
    end

    def delete
      RailsCacheDeliveryMethod.delete(params[:id])
      redirect_to '/gravity_mailbox'
    end

    def delete_all
      RailsCacheDeliveryMethod.delete_all
      redirect_to '/gravity_mailbox'
    end

    private

    def find_preferred_part(*formats)
      if @mail.multipart?
        formats.each do |format|
          part = @mail.find_first_mime_type(format)
          return part if part
        end
      elsif formats.include?(@mail.mime_type)
        @mail.body
      end
    end

    def set_mails
      @mails = RailsCacheDeliveryMethod.mails
      @mail = @mails.detect { |m| m.message_id == params[:id] } if params[:id]
    end
  end
end
