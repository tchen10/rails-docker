module V1
  module Entities
    class UsersEntity < Grape::Entity
      present_collection true
      expose :items, as: 'users', using: V1::Entities::UserEntity
    end
  end
end