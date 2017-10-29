class EventPublisher
  def initialize(queue_name, event, queue_options = {})
    @queue_name = queue_name
    @queue_options = queue_options
    @event = event
  end

  def publish
    exchange = channel.direct 'users-api'
    queue = channel.queue(@queue_name, @queue_options)
              .bind(exchange, :routing_key => @queue_name)
    exchange.publish(@event.to_json, { :routing_key => queue.name,
                                       :content_type => 'application/json' })
    Rails.logger.info "#{self.class.name}: #{@event.to_json} published to queue #{@queue_name}"
    @connection.close
  end

  private

  def channel
    @channel ||= connection.create_channel
  end

  def connection
    begin
      @connection = Bunny.new(ENV['MESSAGE_QUEUE_URL'])
      @connection.start
    end
  end
end