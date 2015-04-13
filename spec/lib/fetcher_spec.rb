require 'rails_helper'
require 'fetcher'
require 'pry'

RATES = '{
  "EUR": 1.22,
  "PLN": 0.33
}'

describe Fetcher do
  let(:fetcher) { Fetcher.new }
  before { allow(fetcher).to receive(:get_rates_from_open_exchange) { RATES } }

  describe '#fetch_currencies' do
    before { fetcher.fetch_currencies }

    it 'returns the last Currency instance' do
      expect(fetcher.fetch_currencies).to eq(Currency.last)
    end

    context 'first request' do
      it 'creates a new Currency instance with correct rates' do
        expect(Currency.count).to eq(1)
        expect(Currency.last.rates).to eq(JSON.parse(RATES))
      end
    end

    context 'request within an hour of the previous request' do
      before do
        Timecop.freeze(59.minutes.from_now)
        fetcher.fetch_currencies
      end

      after { Timecop.return }

      it 'does not create a new Currency instance' do
        expect(Currency.count).to eq(1)
      end
    end

    context 'request after more than an hour of the previous request' do
      before do
        Timecop.freeze(61.minutes.from_now)
        fetcher.fetch_currencies
      end

      after { Timecop.return }

      it 'creates a new Currency instance' do
        expect(Currency.count).to eq(2)
      end
    end
  end
end
