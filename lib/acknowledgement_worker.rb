class AcknowledgementWorker
  include Sneakers::Worker

  from_queue "currencies.acknowledgements"

  def work(message)
    consumer_id = message[:id]
    currency = Currency.find_by(uuid: message[:uuid])
    currency.update_attribute("consumer_#{consumer_id}")

    ack!
  end
end
