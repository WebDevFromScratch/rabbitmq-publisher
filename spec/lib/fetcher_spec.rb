require 'rails_helper'
require 'fetcher'
require 'pry'

RATES = '{
  "EUR": 1.22,
  "PLN": 0.33
}'

describe Fetcher do
  describe '#fetch_currencies' do
    it 'works correctly' do
      fetcher = Fetcher.new
      allow(fetcher).to receive(:get_rates_from_open_exchange) { RATES }
      fetcher.fetch_currencies

      expect(Currency.count).to eq(1)
      expect(Currency.last.rates).to eq(JSON.parse(RATES))
    end
  end
end
