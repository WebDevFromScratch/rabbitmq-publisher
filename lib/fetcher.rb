class Fetcher
  require 'open-uri'

  def fetch_currencies
    Currency.create(rates: get_rates_from_open_exchange)
  end

  def get_rates_from_open_exchange
    JSON.parse(open("https://openexchangerates.org/api/latest.json?app_id=#{ENV['OPEN_EXCHANGE_APP_ID']}").read)
  end
end
