module MailWebCatcher
  class MailWebCatcherController < ActionController::Base
    self.view_paths = File.expand_path("templates", __dir__)

    layout 'application'

    def index
      @mails = MailWebCatcher::RailsCacheDeliveryMethod.mails
      @text = 'Hello World'
    end
  end
end
