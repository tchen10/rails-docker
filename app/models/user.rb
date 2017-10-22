class User < ApplicationRecord
  validates_presence_of :email, :phone_number, :password, :key
  validates_uniqueness_of :email, :phone_number, :key
  validates_length_of :email, :full_name, maximum: 200
  validates_length_of :password, :key, :account_key, maximum: 100
  validates_length_of :phone_number, maximum: 20
  validates_length_of :metadata, maximum: 2000
end
