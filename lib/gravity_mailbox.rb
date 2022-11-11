# frozen_string_literal: true

require_relative 'gravity_mailbox/version'
require_relative 'gravity_mailbox/rails_cache_delivery_method'
require_relative 'gravity_mailbox/railtie' if defined?(Rails)

module GravityMailbox
end
