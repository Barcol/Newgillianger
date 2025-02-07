class Ceremony < ApplicationRecord
  validates :name, presence: true
  validates :event_date, presence: true
  validate :event_date_is_valid_datetime

  private

  def event_date_is_valid_datetime
    if event_date.present? && !event_date.is_a?(Time)
      errors.add(:event_date, "must be a valid datetime")
    end
  end
end