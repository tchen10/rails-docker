module V1
  class UsersApi < Grape::API
    format :json

    resource :users do

      desc 'Return all user records'
      params do
        optional :query, type: String
      end
      get '/' do
        declared_params = declared params, include_missing: false
        present UserSearchService.find(declared_params[:query]), with: V1::Entities::UserEntity
      end
    end
  end
end