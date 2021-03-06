module UserCreator
  include BCrypt

  def self.for(params)
    user = User.create!(email: params[:email],
                       phone_number: params[:phone_number],
                       password: create_password_hash(params[:password]),
                       key: create_unique_key,
                       full_name: params[:full_name],
                       metadata: params[:metadata])
    UserAccountKeyService.request_account_key user.email, user.key
    user
  end

  private

  def self.create_unique_key
    SecureRandom.base64(12)
  end

  def self.create_password_hash(password)
    Password.create(password)
  end
end