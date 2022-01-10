FactoryBot.define do
  factory :stat do
    stat_id { (rand()*1000).ceil }
    stat_name { Faker::Lorem.word }
    stat_display_name { FAKER::Lorem.word }
  end
end