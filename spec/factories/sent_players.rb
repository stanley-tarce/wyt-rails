FactoryBot.define do
  factory :sent_player do
    player_name { Faker::Name.name}
    player_key { (rand()*10000).ceil}
    trade 
  end
end
