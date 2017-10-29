module UserAccountKeyService
  def self.update(email, account_key)
    user = User.find_by_email(email)
    raise ActiveRecord::RecordNotFound if user.nil?

    user.update_attribute(:account_key, account_key)
  end

  def self.request_account_key(email, key)
    new_user_event = NewUserEvent.new(email, key)
    queue_options = { :durable => true,
                      :arguments => { :'x-dead-letter-exchange' => 'new_users-retry' } }

    EventPublisher.new('new_users', new_user_event, queue_options).publish
  end
end