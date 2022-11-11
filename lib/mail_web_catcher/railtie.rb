module MailWebCatcher
  class Railtie < Rails::Railtie # :nodoc:

    initializer "mail_web_catcher.add_delivery_method" do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method(
          :mail_web_catcher_rails_cache,
          MailWebCatcher::RailsCacheDeliveryMethod
        )
      end
    end

    config.after_initialize do |app|
      app.routes.prepend do
        get "/mails" => "mail_web_catcher/mail_web_catcher#index", internal: true
      end
    end
  end
end
