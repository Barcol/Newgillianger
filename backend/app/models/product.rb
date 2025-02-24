class Product < ApplicationRecord
  include SoftDeletable
  
  belongs_to :ceremony

  validates :title, presence: true, length: { minimum: 1, maximum: 64 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
end
