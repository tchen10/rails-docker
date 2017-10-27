class NewUserEvent
  include ActiveModel::Validations

  validates :email, presence: true
  validates :key, presence: true

  def initialize(email, key)
    @email = email
    @key = key
  end
end