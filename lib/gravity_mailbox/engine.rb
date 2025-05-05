# frozen_string_literal: true

require 'rails'
require_relative 'rails_cache_delivery_method'

module GravityMailbox
  class Engine < ::Rails::Engine
    isolate_namespace(GravityMailbox)

    initializer 'gravity_mailbox.add_delivery_method' do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method(
          :gravity_mailbox_rails_cache,
          RailsCacheDeliveryMethod
        )
      end
    end

    initializer 'gravity_mailbox.static_assets' do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
