FactoryBot.define do
  sequence(:body) {|i| "Test body number #{i} "}
  
  factory :answer do
    user
    question
    body
  end
end
