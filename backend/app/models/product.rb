class Product < ApplicationRecord
  belongs_to :ceremony

  validates :title, presence: true, length: { minimum: 1, maximum: 64 }
  validates :price, presence: true
  validates :currency, presence: true
end