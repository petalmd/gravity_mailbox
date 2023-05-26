# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require :default, :development

# require 'gravity_mailbox' already required by bundler
# but Rails is defined after with Combustion.
# Explicitly require railtie to mount routes through railtie.
require 'gravity_mailbox/railtie'

Combustion.initialize!(:action_controller, :action_mailer) do
  config.action_mailer.delivery_method = :gravity_mailbox_rails_cache
  config.action_mailer.perform_deliveries = true
end
run Combustion::Application
