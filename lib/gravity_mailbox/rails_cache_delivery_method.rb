# frozen_string_literal: true

module GravityMailbox
  class RailsCacheDeliveryMethod
    KEY_PREFIX = 'gravity_mailbox/'
    MAILS_LIST_KEY = "#{KEY_PREFIX}list"

    def initialize(options)
      @options = options
    end

    def deliver!(mail)
      key = "#{KEY_PREFIX}#{mail.message_id}"
      Rails.cache.write(key, mail.encoded, expires_in: 1.week) # TODO: setting for expiration
      actual_list = self.class.mail_keys
      Rails.cache.write(MAILS_LIST_KEY, actual_list << key)
    end

    def self.mails
      return [] if mail_keys.empty?

      Rails.cache.read_multi(*mail_keys).values.map do |mail|
        Mail.new(mail)
      end.sort_by(&:date).reverse
    end

    def self.clear
      Rails.cache.delete_matched("#{KEY_PREFIX}*")
    end

    def self.mail_keys
      Rails.cache.read(MAILS_LIST_KEY) || []
    end
  end
end
