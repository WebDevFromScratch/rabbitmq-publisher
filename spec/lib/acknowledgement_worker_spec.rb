require 'rails_helper'

describe AcknowledgementWorker do
  describe '#work' do
    let(:currency) { Currency.last }
    let(:acknowledgement_worker) { AcknowledgementWorker.new }
    before { Currency.create }

    context 'when a Currency is found' do
      let(:message) { { id: 1, uuid: currency[:uuid] }.to_json }

      it 'correctly updates proper `consumer_:id` attribute' do
        acknowledgement_worker.work(message)

        expect(Currency.find(currency[:id])[:consumer_1]).to eq(true)
      end
    end

    context 'when a Currency is not found' do
      let(:message) { { id: 1, uuid: 'some_fake_uuid' }.to_json }

      context 'and there were no more than 5 requeues' do
        it 'returns :requeue' do
          5.times { acknowledgement_worker.work(message) }

          expect(acknowledgement_worker.work(message)).to eq(:requeue)
        end
      end

      context 'and there were more than 5 requeues' do
        it 'returns :reject' do
          6.times { acknowledgement_worker.work(message) }

          expect(acknowledgement_worker.work(message)).to eq(:reject)
        end
      end
    end
  end
end
