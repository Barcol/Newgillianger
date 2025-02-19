FactoryBot.define do
  factory :product do
    title { "Knopers" }
    price { "9.99" }
    currency { "PLN" }
    ceremony { nil }
    deleted_at { nil }
  end
end
