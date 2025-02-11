# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts "Seeding Ceremonies ..."
5.times do
  Ceremony.create(name: "Bijatyka", event_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now))
  Ceremony.create(name: "Korona w remizie", event_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now))
  Ceremony.create(name: "Zabawa w Żębocinie", event_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now))
  Ceremony.create(name: "Pływanie na łaźni", event_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now))
  Ceremony.create(name: "Release Gothic Remake", event_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now))
end
