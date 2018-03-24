FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  
  factory :user do
    email
    password '123456'
    password_confirmation '123456'
  end
  
  factory :invalid_user, class: User do
    email "foo@bar"
    password "123"
    password_confirmation "123"
  end
end
