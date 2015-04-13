class Fetcher
  require 'open-uri'

  attr_accessor :last_request

  def fetch_currencies
    if !self.last_request || self.last_request < Time.now - 1.hour
      self.last_request = Time.now
      Currency.create(rates: get_rates_from_open_exchange)
    else
      Currency.last
    end
  end

  def get_rates_from_open_exchange
    JSON.parse(open("https://openexchangerates.org/api/latest.json?app_id=#{ENV['OPEN_EXCHANGE_APP_ID']}").read)
  end
end
