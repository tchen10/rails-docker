class AccountKeyWorker
  include Sneakers::Worker
  from_queue 'account_keys'

  def work(message)
    Rails.logger.info "#{self.class.name}: Received #{message}"
    begin
      account_key_message = AccountKeyMessage.new.create_from_json(message)
      raise MissingAttributeError unless account_key_message.valid?

      UserAccountKeyService.update(account_key_message.email, account_key_message.account_key)
    rescue MissingAttributeError => e
      Rails.logger.info "#{self.class.name}: #{message} is missing required attributes"
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.info "#{self.class.name}: User associated with email #{account_key_message.email} not found. #{e.message}"
    end
  end
end