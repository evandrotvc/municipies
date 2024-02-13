require 'rails_helper'

RSpec.describe TwilioMessenger, type: :service do
  describe '#call' do
    let(:name) { 'John Doe' }
    let(:phone) { '1234567890' }
    let(:message) { "Olá, #{name}, seu cadastro foi criado/atualizado com sucesso!" }

    it 'sends a message via Twilio' do
      # Simulate Twilio client and message sending
      twilio_client = double('Twilio::REST::Client')
      allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)

      account = double('account')
      messages = double('messages')
      allow(account).to receive(:messages).and_return(messages)
      allow(twilio_client).to receive(:account).and_return(account)

      expect(messages).to receive(:create).with(from: '+15076154581', to: "+#{phone}",
        body: message)

      described_class.new(message, phone).call
    end
  end
end
