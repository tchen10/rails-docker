class AccountKeyWorker
  include Sneakers::Worker
  from_queue 'account_keys',
             { :arguments => {:'x-dead-letter-exchange' => 'account_keys-retry'} }

  def work(message)
    Sneakers.logger.info "#{self.class.name} Received #{message}"
    begin
      account_key_message = AccountKeyMessage.new.create_from_json(message)
      raise MissingAttributeError unless account_key_message.valid?

      UserAccountKeyService.update(account_key_message.email, account_key_message.account_key)
      ack!
    rescue MissingAttributeError => e
      Sneakers.logger.info "#{self.class.name} Message received is missing required attributes. #{message}"
      reject!
    rescue ActiveRecord::RecordNotFound => e
      Sneakers.logger.info "#{self.class.name} User associated with email #{account_key_message.email} not found."
      reject!
    end
  end
end