FactoryBot.define do
  factory :product do
    title { Faker::Food.dish }
    price { "9.99" }
    currency { "PLN" }
    ceremony
    deleted_at { nil }

    trait :deleted do
      deleted_at { Time.current }
    end

    trait :without_ceremony do
      ceremony { nil }
    end
  end
end
