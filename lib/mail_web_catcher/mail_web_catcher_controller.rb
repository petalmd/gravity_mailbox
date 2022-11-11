module MailWebCatcher
  class MailWebCatcherController < ActionController::Base
    self.view_paths = File.expand_path("templates", __dir__)

    layout 'application'

    def index
      @emails = RailsCacheDeliveryMethod.mails
      @email = @emails[params[:index].to_i]
      if @email
        @part = find_preferred_part(request.format, Mime[:html], Mime[:text])
      end
      if params[:part]
        response.content_type = 'text/html'
        render plain: @email.part[1].body.decoded
      end
    end

    def clear
      RailsCacheDeliveryMethod.clear
      redirect_to '/mails'
    end

    private

    def find_preferred_part(*formats) # :doc:
      formats.each do |format|
        if part = @email.find_first_mime_type(format)
          return part
        end
      end

      if formats.any? { |f| @email.mime_type == f }
        @email
      end
    end
  end
end
