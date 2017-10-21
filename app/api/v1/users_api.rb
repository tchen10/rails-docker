module V1
  class UsersApi < Grape::API
    format :json

    resource :users do
      desc 'Return user records'
      params do
        optional :query, type: String
      end
      get '/' do
        declared_params = declared params, include_missing: false
        present UserSearchService.find(declared_params[:query]), with: V1::Entities::UserEntity
      end

      desc 'Create a user'
      params do
        requires :email, type: String
        requires :phone_number, type: String
        requires :password, type: String
        optional :full_name, type: String
        optional :metadata, type: String
      end
      post '/' do
        declared_params = declared params
        present UserCreator.for(declared_params), with: V1::Entities::UserEntity
      end
    end
  end
end