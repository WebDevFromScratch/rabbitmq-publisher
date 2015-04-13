require 'rails_helper'

describe Currency do
  context 'on create' do
    let(:currency) { Currency.create }

    it 'generates uuid' do
      expect(currency.uuid).to be_truthy
      expect(currency.uuid.length).to eq(SecureRandom.uuid.length)
    end
  end
end
