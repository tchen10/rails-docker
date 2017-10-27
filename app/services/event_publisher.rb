class EventPublisher
  def initialize(queue_name, event)
    @queue_name = queue_name
    @event = event
  end

  def publish
    queue = channel.queue(@queue_name, :durable => true)
    exchange = channel.default_exchange
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
    rescue Bunny::TCPConnectionFailed => e
      Rails.logger.warn "Connection to #{ENV['MESSAGE_QUEUE_URL']} failed"
    rescue Bunny::PossibleAuthenticationFailureError => e
      Rails.logger.warn "Could not authenticate as #{@connection.username}"
    end
  end
end