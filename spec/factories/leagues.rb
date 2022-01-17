FactoryBot.define do
  factory :league do
    league_id { (rand()*10000).ceil}
    user
  end
end
