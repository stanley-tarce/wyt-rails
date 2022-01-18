FactoryBot.define do
  factory :received_player do
    player_name { Faker::Name.name}
    player_key { (rand()*10000).ceil}
    trade
  end
end
