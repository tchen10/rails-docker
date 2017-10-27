require 'sneakers'

Sneakers.configure(:amqp => ENV['MESSAGE_QUEUE_URL'],
                   :timeout_job_after => 5,
                   :prefetch => 10,
                   :threads => 10,
                   :durable => true)

Sneakers.logger.level = Logger::INFO