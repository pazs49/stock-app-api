FactoryBot.define do
  factory :user do
    email { "testuser@email.com" }
    password { "password" }
    confirmed_at { Time.current }
    user_info_attributes { FactoryBot.attributes_for(:user_info) }
  end

  trait :admin do
    email { "testadmin@email.com" }
    after(:create) do |user|
      user.user_info.update!(admin: true)
    end
  end
end
