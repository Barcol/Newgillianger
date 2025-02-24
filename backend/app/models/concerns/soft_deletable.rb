module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
    scope :inactive, -> { where.not(deleted_at: nil) }
  end

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

  def active?
    deleted_at.nil?
  end

  def inactive?
    deleted_at.present?
  end
end
