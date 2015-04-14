require 'rails_helper'

MESSAGE = '{
  uuid: "some-randomly-generated-uuid",
  rates: {
    "AUD": 1.22,
    "PLN": 0.33
  }
}'

describe Publisher do
  describe '.publish' do
    let(:fanout) { double('fanout', publish: MESSAGE) }
    let(:channel) { double('channel', fanout: fanout) }

    before do
      allow(Publisher).to receive(:message) { MESSAGE }
      allow(Publisher).to receive(:channel) { channel }
    end

    it 'should publish a correct message to correct fanout' do
      Publisher.publish

      expect(fanout).to have_received(:publish).with(MESSAGE)
    end
  end
end
