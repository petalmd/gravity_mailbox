# frozen_string_literal: true

RSpec.describe GravityMailbox::RailsCacheDeliveryMethod do
  describe '.deliver!' do
    subject(:delivering) { described_class.new({}).deliver!(mail) }

    let(:mail) do
      Mail.new.tap do |m|
        m.message_id = '123'
        m.from = 'sender@example.com'
        m.to = 'recipient@example.com'
      end
    end

    before do
      allow(Rails.cache).to receive(:write)
    end

    it 'stores the mail in the cache' do
      delivering
      expect(Rails.cache).to have_received(:write).with(
        "gravity_mailbox/#{mail.message_id}",
        mail.encoded,
        expires_in: 1.week
      )
      expect(Rails.cache).to have_received(:write).with(
        'gravity_mailbox/list',
        ["gravity_mailbox/#{mail.message_id}"]
      )
    end

    context 'envelope validation' do
      context 'when mail has no sender' do
        let(:mail) do
          Mail.new.tap do |m|
            m.message_id = '123'
            m.to = 'recipient@example.com'
          end
        end

        it 'raises an error' do
          expect { delivering }.to raise_error(ArgumentError, /SMTP From address may not be blank/)
        end
      end

      context 'when mail has no recipients' do
        let(:mail) do
          Mail.new.tap do |m|
            m.message_id = '123'
            m.from = 'sender@example.com'
          end
        end

        it 'raises an error' do
          expect { delivering }.to raise_error(ArgumentError, /SMTP To address may not be blank/)
        end
      end

      context 'when mail has invalid from address' do
        let(:mail) do
          Mail.new.tap do |m|
            m.message_id = '123'
            m.from = ''
            m.to = 'recipient@example.com'
          end
        end

        it 'raises an error' do
          expect { delivering }.to raise_error(ArgumentError, /SMTP From address may not be blank/)
        end
      end
    end
  end

  describe '#mails' do
    subject(:mails) { described_class.mails }

    let(:cached_mails) { [mail_today, mail_yesterday] }
    let(:mail_yesterday) do
      Mail.new.tap do |m|
        m.message_id = '456'
        m.date = Date.today - 1
      end
    end
    let(:mail_today) do
      Mail.new.tap do |m|
        m.message_id = '123'
        m.date = Date.today
      end
    end

    before do
      allow(described_class).to receive(:mail_keys).and_return(cached_mails.map(&:message_id))
      allow(Rails.cache).to receive(:read_multi).with(*cached_mails.map(&:message_id)) do
        cached_mails.each_with_object({}) do |mail, hash|
          hash[mail.message_id] = mail.encoded
        end
      end
    end

    context 'when cache is empty' do
      it 'returns an empty array' do
        allow(described_class).to receive(:mail_keys).and_return([])
        expect(mails).to eq []
      end
    end

    it 'returns instances of Mail in date desc' do
      expect(mails.map(&:message_id)).to eq cached_mails.map(&:message_id)
    end

    context 'when reverse order' do
      let(:cached_mails) { [mail_today, mail_yesterday].reverse }

      it 'ensure to reorder' do
        expect(mails.map(&:message_id)).to eq cached_mails.map(&:message_id).reverse
      end
    end
  end

  describe '#mail' do
    subject(:mail) { described_class.mail(id) }

    let(:id) { '123' }
    let(:cached_mail) do
      Mail.new.tap do |m|
        m.message_id = id
      end
    end

    before do
      allow(Rails.cache).to receive(:read).with("gravity_mailbox/#{id}").and_return(cached_mail.encoded)
    end

    it 'returns an instance of Mail' do
      expect(mail.message_id).to eq id
      expect(mail.encoded).to eq cached_mail.encoded
    end
  end

  describe '#delete' do
    subject(:delete) { described_class.delete(id) }

    let(:id) { '123' }

    before do
      allow(Rails.cache).to receive(:delete).with("gravity_mailbox/#{id}")
      allow(described_class).to receive(:mail_keys).and_return(["gravity_mailbox/#{id}"])
      allow(Rails.cache).to receive(:write)
    end

    it 'deletes the mail from the cache' do
      delete
      expect(Rails.cache).to have_received(:delete).with("gravity_mailbox/#{id}")
      expect(Rails.cache).to have_received(:write).with('gravity_mailbox/list', [])
    end
  end

  describe '#delete_all' do
    subject(:delete_all) { described_class.delete_all }

    before do
      allow(Rails.cache).to receive(:delete_matched).with('gravity_mailbox/*')
    end

    it 'deletes all mails from the cache' do
      delete_all
      expect(Rails.cache).to have_received(:delete_matched).with('gravity_mailbox/*')
    end
  end

  describe '#mail_keys' do
    context 'when cache is empty' do
      it 'returns an empty array' do
        allow(Rails.cache).to receive(:read).with('gravity_mailbox/list').and_return(nil)
        expect(described_class.mail_keys).to eq []
      end
    end

    context 'when cache is not empty' do
      it 'returns an array of mail keys' do
        allow(Rails.cache).to receive(:read).with('gravity_mailbox/list').and_return(['gravity_mailbox/123'])
        expect(described_class.mail_keys).to eq ['gravity_mailbox/123']
      end
    end
  end
end
