require 'rails_helper'

RSpec.describe V1::UsersApi do
  describe 'GET /users' do

    context 'success' do
      let(:user_1) { create :user, email: 'user1@email.com' }
      let(:user_2) { create :user, email: 'user2@email.com' }

      it 'calls user search service with query parameter' do
        expect(UserSearchService).to receive(:find).with('query')
                                       .and_return([user_1, user_2])

        get '/v1/users?query=query'

        expect(response.status).to eq 200
        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'returns user with attributes' do
        expect(UserSearchService).to receive(:find).and_return([user_1])

        get '/v1/users'

        expect(response.status).to eq 200
        user_response = JSON.parse(response.body).first
        expect(user_response.keys).to contain_exactly('email', 'phone_number', 'full_name', 'key', 'account_key', 'metadata')
      end

      it 'returns empty array when service does not return users' do
        expect(UserSearchService).to receive(:find).and_return([])

        get '/v1/users'

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq []
      end
    end
  end
end