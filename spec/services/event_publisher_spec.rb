require 'rails_helper'

RSpec.describe EventPublisher do
  describe '.publish' do
    test_event = { 'hello': 'world' }
    before :each do
      @mock_bunny = BunnyMock.new
      allow(Bunny).to receive(:new).and_return(@mock_bunny)


      EventPublisher.new('test.queue',
                         test_event,
                         {:durable => true}).publish
    end

    it 'binds exchange to the correct queue' do
      exchange = @mock_bunny.exchanges['users-api']
      queue = @mock_bunny.queues['test.queue']

      expect(queue.bound_to? exchange).to eq true
    end

    it 'adds expected queue options' do
      queue = @mock_bunny.queues['test.queue']
      expect(queue.opts).to eq ({:durable => true})
    end

    it 'publishes the event to queue with expected message options' do
      queue = @mock_bunny.queues['test.queue']
      expect(queue.message_count).to eq 1

      last_message = queue.all.first

      expect(last_message[:message]).to eq test_event.to_json
      expect(last_message[:options][:routing_key]).to eq 'test.queue'
      expect(last_message[:options][:exchange]).to eq 'users-api'
    end
  end
end