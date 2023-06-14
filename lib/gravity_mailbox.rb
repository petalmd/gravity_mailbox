# frozen_string_literal: true

require_relative 'gravity_mailbox/version'
require_relative 'gravity_mailbox/rails_cache_delivery_method'
require_relative 'gravity_mailbox/engine' if defined?(Rails)

module GravityMailbox
end
