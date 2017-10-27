require 'rails_helper'

RSpec.describe UserAccountKeyService do
  describe '#update' do
    context 'when email exists in the system' do
      it 'updates user with new account key' do
        email = 'existingUser@email.com'
        account_key = 'new account key'
        create :user, email: email

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

  describe '#request_account_key' do
    it 'calls EventPublisher to publish NewUserEvent' do
      email = 'user@email.com'
      key = 'random_key'

      new_user_event = double(NewUserEvent)
      expect(NewUserEvent).to receive(:new).with(email, key).and_return(new_user_event)

      event_publisher = double(EventPublisher)
      expect(EventPublisher).to receive(:new).with('new_users', new_user_event).and_return(event_publisher)
      expect(event_publisher).to receive(:publish)

      UserAccountKeyService.request_account_key email, key
    end
  end
end