require 'rails_helper'

RSpec.describe UserAccountKeyService do
  describe '#update' do
    context 'when email exists in the system' do
      it 'updates user with new account key' do
        email = 'existingUser@email.com'
        account_key = 'new account key'
        create :user, :stop_callback, email: email

        UserAccountKeyService.update email,account_key

        db_user = User.first
        expect(db_user.account_key).to eq account_key
      end
    end

    context 'when email does not exist in the system' do
      it 'raises RecordNotFound error' do
        email = 'lostUser@email.com'
        account_key = 'some account key'
        expect { UserAccountKeyService.update email,account_key }
          .to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end