require 'rails_helper'

RSpec.describe AccountKeyWorker do
  before :each do
    logger = double(Sneakers.logger)
    allow(Sneakers).to receive(:logger).and_return(logger)
    allow(logger).to receive(:info)
  end

  describe '.work' do
    email = 'user@email.com'
    account_key = 'new account key'

    before :each do
      @account_key_worker = AccountKeyWorker.new
    end

    it 'calls user account key service with email and key' do
      message = {
        email: email,
        account_key: account_key
      }.to_json

      expect(UserAccountKeyService).to receive(:update).with(email, account_key)
      expect(@account_key_worker).to receive(:ack!)

      @account_key_worker.work message
    end

    context 'when message in invalid' do
      it 'logs the error' do
        message = {
          account_key: account_key
        }.to_json

        account_key_message = double(AccountKeyMessage)
        expect(AccountKeyMessage).to receive(:new).and_return(account_key_message)
        expect(account_key_message).to receive(:create_from_json).with(message)
                                       .and_raise(MissingAttributeError)

        expect(@account_key_worker).to receive(:reject!)

        @account_key_worker.work message
      end
    end

    context 'when the user record cannot be found' do
      it 'logs the error' do
        message = {
          email: 'not a user',
          account_key: account_key
        }.to_json

        expect(UserAccountKeyService).to receive(:update).with('not a user', account_key)
                                           .and_raise(ActiveRecord::RecordNotFound)

        expect(@account_key_worker).to receive(:reject!)

        @account_key_worker.work message
      end
    end
  end
end