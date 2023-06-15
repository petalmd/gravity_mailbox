# frozen_string_literal: true

RSpec.describe GravityMailbox::MailboxController, type: :controller do # rubocop:disable RSpec/Rails/InferredSpecType
  before do
    @routes = GravityMailbox::Engine.routes
  end

  describe 'GET #index' do
    context 'with no mail params' do
      let(:stub_mails) { 'stub mails' }

      it 'render the index html template' do
        allow(GravityMailbox::RailsCacheDeliveryMethod).to receive(:mails).and_return(stub_mails)
        get :index
        expect(response).to have_http_status :ok
        expect(response).to render_template(:index)
        expect(response.content_type).to match(%r{text/html})
        expect(assigns(:mails)).to eq stub_mails
      end
    end

    context 'when mail part params is true' do
      before do
        allow(controller).to receive(:email_body).and_return('email body')
      end

      it 'render the plain text template' do
        get :index, params: { part: true }
        expect(response).to have_http_status :ok
        expect(response.content_type).to match(%r{text/html})
        expect(response).not_to render_template(:index)
      end
    end

    context 'when params id is present' do
      let(:message_id) { 'message_id' }
      let(:stub_mail) do
        Mail.new.tap do |m|
          m.message_id = message_id
          m.content_type = 'text/plain'
          m.body = 'body'
        end
      end
      let(:stub_mails) { [stub_mail] }

      before do
        allow(GravityMailbox::RailsCacheDeliveryMethod).to receive(:mails).and_return(stub_mails)
      end

      it 'render the plain text template' do
        get :index, params: { id: message_id, part: true }
        expect(response).to have_http_status :ok
        expect(response.content_type).to match(%r{text/html})
        expect(response).not_to render_template(:index)
        expect(assigns(:mail)).to eq stub_mail
        expect(response.body).to eq 'body'
      end

      context 'when mail is html only' do
        let(:stub_mail) do
          Mail.new.tap do |m|
            m.message_id = message_id
            m.content_type = 'text/html'
            m.body = '<h1>This is HTML</h1>'
          end
        end

        it 'render the html template' do
          get :index, params: { id: message_id, part: true }
          expect(response).to have_http_status :ok
          expect(response.content_type).to match(%r{text/html})
          expect(response).not_to render_template(:index)
          expect(assigns(:mail)).to eq stub_mail
          expect(response.body).to eq stub_mail.body.decoded
        end
      end
    end

    context 'when params id and select format' do
      let(:message_id) { 'message_id' }
      let(:html_part) do
        Mail::Part.new do
          content_type 'text/html; charset=UTF-8'
          body '<h1>This is HTML</h1>'
        end
      end

      let(:text_part) do
        Mail::Part.new do
          body 'This is plain text'
        end
      end
      let(:stub_mail) do
        Mail.new.tap do |m|
          m.message_id = message_id
          m.text_part = text_part
          m.html_part = html_part
        end
      end
      let(:stub_mails) { [stub_mail] }

      before do
        allow(GravityMailbox::RailsCacheDeliveryMethod).to receive(:mails).and_return(stub_mails)
      end

      it 'return plain html part' do
        get :index, params: { id: message_id, part: true }, format: :html
        expect(response).to have_http_status :ok
        expect(response.content_type).to match(%r{text/html})
        expect(response).not_to render_template(:index)
        expect(assigns(:mail)).to eq stub_mail
        expect(response.body).to eq html_part.body.decoded
      end

      it 'return plain text part' do
        get :index, params: { id: message_id, part: true }, format: :text
        expect(response).to have_http_status :ok
        expect(response.content_type).to match(%r{text/html})
        expect(response).not_to render_template(:index)
        expect(assigns(:mail)).to eq stub_mail
        expect(response.body).to eq text_part.body.decoded
      end
    end
  end
end
