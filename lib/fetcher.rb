class Fetcher
  require 'open-uri'

  def self.fetch_currencies
    if !Currency.last || Currency.last.created_at < 1.hour.ago
      Currency.create(rates: self.get_rates_from_open_exchange)
    else
      Currency.last
    end
  end

  def self.get_rates_from_open_exchange
    JSON.parse(open("https://openexchangerates.org/api/latest.json?app_id=#{ENV['OPEN_EXCHANGE_APP_ID']}").read)
  end
end
