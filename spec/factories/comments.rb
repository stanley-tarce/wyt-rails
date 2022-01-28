FactoryBot.define do
  factory :comment do
    name { Faker::Name.name}
    description { Faker::Lorem.paragraph}
    trade
  end
end
