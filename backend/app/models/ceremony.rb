class Ceremony < ApplicationRecord
  include SoftDeletable

  has_many :products, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255, message: "is too long (maximum is 255 characters)" }
  validates :event_date, presence: true
  validate :event_date_is_valid_datetime

  private

  def event_date_is_valid_datetime
    if event_date.present? && !event_date.is_a?(Time)
      errors.add(:event_date, "must be a valid datetime")
    end
  end
end
