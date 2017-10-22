module UserAccountKeyService
  def self.update(email, account_key)
    user = User.find_by_email(email)
    raise ActiveRecord::RecordNotFound if user.nil?

    user.update_attribute(:account_key, account_key)
  end
end