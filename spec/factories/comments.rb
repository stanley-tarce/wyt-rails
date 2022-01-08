FactoryBot.define do
  factory :comment do
    name { Faker::Name.name}
    comment { Faker::Lorem.paragraph}
    trade
  end
end
