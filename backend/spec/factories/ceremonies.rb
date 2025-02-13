FactoryBot.define do
  factory :ceremony do
    name { "Okret nasz wplynie w mgle" }
    event_date { Time.now + 1.week }
    deleted_at { nil }

    trait :discarded do
      deleted_at { Time.current }
    end
  end
end
