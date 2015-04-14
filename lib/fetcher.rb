class Fetcher
  require 'open-uri'

  def self.fetch_currencies
    if !Currency.last || Currency.last.created_at < 1.hour.ago
      Currency.create(rates: parse_rates)
    else
      Currency.last
    end
  end

  private

  def self.parse_rates
    JSON.parse(get_rates)
  end

  def self.get_rates
    open("https://openexchangerates.org/api/latest.json?app_id=#{ENV['OPEN_EXCHANGE_APP_ID']}").read
  end
end
