# frozen_string_literal: true

require_relative 'mailbox_controller'

module GravityMailbox
  class Railtie < ::Rails::Railtie # :nodoc:
    initializer 'gravity_mailbox.add_delivery_method' do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method(
          :gravity_mailbox_rails_cache,
          RailsCacheDeliveryMethod
        )
      end
    end

    config.after_initialize do |app|
      app.routes.prepend do
        get '/gravity_mailbox' => 'gravity_mailbox/mailbox#index', internal: true
        post '/gravity_mailbox/delete_all' => 'gravity_mailbox/mailbox#delete_all', internal: true
        get '/gravity_mailbox/download_eml' => 'gravity_mailbox/mailbox#download_eml', internal: true
        post '/gravity_mailbox/delete' => 'gravity_mailbox/mailbox#delete', internal: true
      end
    end
  end
end
