FactoryBot.define do
  factory :sent_player do
    player_name { Faker::Name.name}
    trade 
  end
end
