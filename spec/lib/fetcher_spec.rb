require 'rails_helper'

RATES = '{
  "EUR": 1.22,
  "PLN": 0.33
}'

describe Fetcher do
  before { allow(Fetcher).to receive(:parse_rates) { RATES } }

  describe '.fetch_currencies' do
    before { Fetcher.fetch_currencies }

    it 'returns the last Currency instance' do
      expect(Fetcher.fetch_currencies).to eq(Currency.last)
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
        Fetcher.fetch_currencies
      end

      after { Timecop.return }

      it 'does not create a new Currency instance' do
        expect(Currency.count).to eq(1)
      end
    end

    context 'request after more than an hour of the previous request' do
      before do
        Timecop.freeze(61.minutes.from_now)
        Fetcher.fetch_currencies
      end

      after { Timecop.return }

      it 'creates a new Currency instance' do
        expect(Currency.count).to eq(2)
      end
    end
  end
end
