require 'rails_helper'

RSpec.describe V1::UsersApi do
  describe 'GET /users' do
    context 'success' do
      it 'returns all users when users exist in database' do
        create :user, email: 'user1@email.com'
        create :user, email: 'user2@email.com'

        get '/v1/users'

        expect(response.status).to eq 200
        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'returns user with attributes' do
        create :user

        get '/v1/users'

        expect(response.status).to eq 200
        user_response = JSON.parse(response.body).first
        expect(user_response).to have_key('email')
        expect(user_response).to have_key('phone_number')
        expect(user_response).to have_key('full_name')
        expect(user_response).to have_key('key')
        expect(user_response).to have_key('account_key')
        expect(user_response).to have_key('metadata')
      end

      it 'returns empty array when no users exist in database'do
        get '/v1/users'

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq []
      end
    end
  end
end