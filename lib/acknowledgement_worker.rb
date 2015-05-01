class AcknowledgementWorker
  include Sneakers::Worker

  from_queue "currencies.acknowledgements"

  def work(message)
    message = JSON.parse(message)
    consumer_id = message['id']
    currency = Currency.find_by(uuid: message['uuid'])

    if currency
      currency.update_attribute("consumer_#{consumer_id}", true)
      ack!
    else
      Airbrake.notify(error_class: 'SendingError')
      requeue_or_reject
    end
  end

  private

  def requeue_or_reject
    if !@countdown
      @countdown = 5
      requeue!
    elsif @countdown > 0
      @countdown -= 1
      requeue!
    else
      reject!
    end
  end
end
