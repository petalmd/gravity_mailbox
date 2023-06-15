# frozen_string_literal: true

RSpec.describe GravityMailbox::Engine do
  describe 'delivery method' do
    it 'adds the delivery method' do
      expect(ActionMailer::Base.delivery_methods.keys).to include(:gravity_mailbox_rails_cache)
    end
  end
end
