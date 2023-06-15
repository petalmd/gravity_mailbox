# frozen_string_literal: true

require 'gravity_mailbox'
require 'combustion'
require 'action_mailer'

Combustion.initialize!(:action_controller, :action_mailer) do
  config.action_mailer.delivery_method = :gravity_mailbox_rails_cache
  config.action_mailer.perform_deliveries = true
  config.cache_store = :null_store
end

require 'rspec/rails'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
