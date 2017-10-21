module V1
  class UsersApi < Grape::API
    helpers ApiErrorHelper
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
        requires :email, type: String, desc: 'unique email address of user'
        requires :phone_number, type: String, desc: 'unique phone number of user'
        requires :password, type: String, desc: 'password of user'
        optional :full_name, type: String, desc: 'full name of user'
        optional :metadata, type: String, desc: 'unstructured data about the user'
      end
      post '/' do
        declared_params = declared params
        begin
          present UserCreator.for(declared_params), with: V1::Entities::UserEntity
        rescue ActiveRecord::RecordInvalid => invalid
          error_for 422, invalid, :record_invalid
        rescue => error
          error_for 400, error
        end
      end
    end

    rescue_from Grape::Exceptions::ValidationErrors do |error|
      error_for 422, error, :grape_validation_error
    end
  end
end