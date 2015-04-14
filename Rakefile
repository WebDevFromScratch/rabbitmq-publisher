# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :rabbitmq do
  desc "Setup routing"
  task :setup do
    require "bunny"

    conn = Bunny.new
    conn.start

    ch = conn.create_channel

    x1 = ch.fanout("currencies.fanout")
    x2 = ch.direct("currencies.direct")

    q1 = ch.queue("currencies.queue_1", durable: true)
    q2 = ch.queue("currencies.queue_2", durable: true)
    q3 = ch.queue("currencies.queue_3", durable: true)
    q4 = ch.queue("currencies.acknowledgements", durable: true)

    q1.bind("currencies.fanout")
    q2.bind("currencies.fanout")
    q3.bind("currencies.fanout")
    q4.bind("currencies.direct", routing_key: "acknowledgements")

    conn.stop
  end
end
