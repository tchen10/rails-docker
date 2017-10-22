require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone_number) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:key) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:phone_number) }
  it { should validate_uniqueness_of(:key) }
  it { should validate_length_of(:email).is_at_most(200) }
  it { should validate_length_of(:full_name).is_at_most(200) }
  it { should validate_length_of(:password).is_at_most(100) }
  it { should validate_length_of(:key).is_at_most(100) }
  it { should validate_length_of(:account_key).is_at_most(100) }
  it { should validate_length_of(:phone_number).is_at_most(20) }
  it { should validate_length_of(:metadata).is_at_most(2000) }

  describe '.retrieve_account_key' do
    it 'calls AccountKeyWorker after creation' do
      email = 'user@email.com'
      key = 'random_key'

      account_key_worker = double(AccountKeyWorker)
      expect(AccountKeyWorker).to receive(:new).and_return(account_key_worker)
      expect(account_key_worker).to receive(:perform).with(email, key)

      create :user, email: email, key: key
    end
  end
end
