# frozen_string_literal: true

require 'rails'

module GravityMailbox
  class Engine < ::Rails::Engine # :nodoc:
    isolate_namespace(GravityMailbox)

    initializer 'gravity_mailbox.add_delivery_method' do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method(
          :gravity_mailbox_rails_cache,
          RailsCacheDeliveryMethod
        )
      end
    end
  end
end
