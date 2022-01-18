FactoryBot.define do
  factory :session do
    token { (rand()*100000000).ceil}
    user
  end
end
