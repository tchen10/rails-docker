module UserAccountKeyService
  def self.update(email, account_key)
    user = User.find_by_email(email)
    raise ActiveRecord::RecordNotFound if user.nil?

    user.update_attribute(:account_key, account_key)
  end

  def self.request_account_key(email, key)
    EventPublisher.new('new_users', NewUserEvent.new(email, key)).publish
  end
end