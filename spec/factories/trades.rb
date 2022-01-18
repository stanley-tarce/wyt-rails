FactoryBot.define do
  factory :trade do
    team_name { Faker::Team.name }
    team_key { (rand()*10000).ceil}
    league
  end
end
