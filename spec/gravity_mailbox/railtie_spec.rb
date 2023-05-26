# frozen_string_literal: true

RSpec.describe GravityMailbox::Railtie do
  describe 'delivery method' do
    it 'adds the delivery method' do
      expect(ActionMailer::Base.delivery_methods.keys).to include(:gravity_mailbox_rails_cache)
    end
  end

  describe 'routes' do
    it 'mounts the routes' do
      underscore_class_name = GravityMailbox::MailboxController.name.underscore.gsub('_controller', '')

      # Get the actual actions defined in the routes
      routes_actions = Rails.application.routes.routes.map do |route|
        route.defaults[:action] if route.defaults[:controller] == underscore_class_name
      end.compact

      # Compare the expected and actual actions
      expect(routes_actions).to match_array(GravityMailbox::MailboxController.action_methods)
    end
  end
end
