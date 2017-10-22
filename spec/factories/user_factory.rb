FactoryBot.define do
  factory :user, class: User do
    trait :stop_callback do
      before(:create) { |user| user.define_singleton_method(:retrieve_account_key) {} }
    end

    # required
    email 'user@email.com'

    sequence :phone_number do |phone_number|
      "#{Random.rand(000000000..999999999)}"
    end

    sequence :key do |key|
      "#{Random.rand(1..1000)}"
    end

    password 'secret password'

    # optional
    full_name ''
    metadata ''
    account_key ''
  end
end