require 'rails_helper'

RSpec.describe AccountKeyWorker do
  describe '.perform' do
    email = 'user@email.com'
    key = 'random key'

    before :each do
      @account_key_gateway = double(AccountKeyGateway)
      expect(AccountKeyGateway).to receive(:new).and_return(@account_key_gateway)
    end

    it 'calls gateway with email and key' do
      expect(@account_key_gateway).to receive(:account_key_for).with(email, key)

      AccountKeyWorker.new.perform email, key
    end

    context 'when there is a gateway error' do
      it 'reschedules job to run in 10 minutes' do
        expect(@account_key_gateway).to receive(:account_key_for).with(email, key)
                                          .and_raise(GatewayError)
        expect(AccountKeyWorker).to receive(:perform_in).with(10.minutes, email, key)
        AccountKeyWorker.new.perform email, key
      end
    end

    context 'when the user record cannot be found' do
      it 'logs the error' do
        expect(@account_key_gateway).to receive(:account_key_for).with(email, key)
                                          .and_raise(ActiveRecord::RecordNotFound)
        AccountKeyWorker.new.perform email, key
      end
    end

    context 'when there is some other system failure' do
      it 'does not retry the job' do
        expect(@account_key_gateway).to receive(:account_key_for).with(email, key)
                                          .and_raise(ActiveRecord::RecordNotFound)
        AccountKeyWorker.new.perform email, key
      end
    end
  end
end