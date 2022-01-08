FactoryBot.define do
  factory :received_player do
    player_name { Faker::Name.name}
    trade
  end
end
