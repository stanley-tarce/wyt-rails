FactoryBot.define do
  factory :league do
    league_name { "NBA League" }
    league_id { (rand()*10000).ceil}
    user
  end
end
