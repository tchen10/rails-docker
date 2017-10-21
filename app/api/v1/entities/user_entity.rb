module V1
  module Entities
    class UserEntity < Grape::Entity
      expose :email
      expose :phone_number
      expose :full_name
      expose :key
      expose :account_key
      expose :metadata
    end
  end
end