# frozen_string_literal: true

require 'mail'

module GravityMailbox
  class RailsCacheDeliveryMethod
    KEY_PREFIX = 'gravity_mailbox/'
    MAILS_LIST_KEY = "#{KEY_PREFIX}list"

    attr_accessor :settings

    def initialize(settings)
      @settings = settings
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

    def self.mail(id)
      Mail.new(Rails.cache.read("#{KEY_PREFIX}#{id}"))
    end

    def self.delete(id)
      Rails.cache.delete("#{KEY_PREFIX}#{id}")
      actual_list = mail_keys
      actual_list.delete("#{KEY_PREFIX}#{id}")
      Rails.cache.write(MAILS_LIST_KEY, actual_list)
    end

    def self.delete_all
      Rails.cache.delete_matched("#{KEY_PREFIX}*")
    end

    def self.mail_keys
      Rails.cache.read(MAILS_LIST_KEY) || []
    end
  end
end
