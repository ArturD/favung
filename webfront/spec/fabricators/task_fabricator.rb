Fabricator(:task) do
  name { Faker::Name.name }
  description { Faker::Lorem.paragraph }
end
