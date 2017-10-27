require 'rails_helper'

RSpec.describe AccountKeyMessage, type: :model do
  describe 'validations' do
    it 'validates presence of account_key' do
      message = {
        email: 'user@email.com'
      }.to_json

      account_key_message = AccountKeyMessage.new.create_from_json(message)

      expect(account_key_message.valid?).to be false
    end

    it 'validates presence of email' do
      message = {
        account_key: 'new account key'
      }.to_json

      account_key_message = AccountKeyMessage.new.create_from_json(message)

      expect(account_key_message.valid?).to be false
    end
  end

  describe '.create_from_json' do
    it 'parses json and sets values' do
      message = {
        email: 'user@email.com',
        account_key: 'new account key'
      }.to_json

      account_key_message = AccountKeyMessage.new.create_from_json(message)

      expect(account_key_message.email).to eq 'user@email.com'
      expect(account_key_message.account_key).to eq 'new account key'
    end
  end
end
