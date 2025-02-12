FactoryBot.define do
  factory :ceremony do
    name { "Okret nasz wplynie w mgle" }
    event_date { Time.now + 1.week }
  end
end
