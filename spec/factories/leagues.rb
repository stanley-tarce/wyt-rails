FactoryBot.define do
  factory :league do
    league_key { (rand()*10000).ceil}
    team_name { Faker::Team.name }
    team_key { (rand()*10000).ceil}
    user
  end
end
