require 'rails_helper'

describe AcknowledgementWorker do
  describe '#work' do
    it 'correctly updates proper `consumer_:id` attribute' do
      currency = Currency.create
      acknowledgement_worker = AcknowledgementWorker.new
      message = { id: 1, uuid: currency[:uuid] }

      acknowledgement_worker.work(message)

      expect(Currency.find(currency[:id])[:consumer_1]).to eq(true)
    end
  end
end
