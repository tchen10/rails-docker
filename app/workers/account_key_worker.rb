class AccountKeyWorker
  include Sneakers::Worker
  from_queue 'account_keys'

  def work(msg)
    Rails.logger.info "#{self.class.name}: Received #{msg}"
    message = JSON.parse(msg)
    raise MissingAttributeError if message['email'].nil? || message['account_key'].nil?

    response_email = message['email']
    response_account_key = message['account_key']

    begin
      UserAccountKeyService.update(response_email, response_account_key)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.info "#{self.class.name}: User associated with email #{response_email} not found. #{e.message}"
    end
  end
end