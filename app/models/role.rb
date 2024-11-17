class Role < ApplicationRecord
  belongs_to :company
  belongs_to :user

  ROL_SUPERVISOR = 0
  ROL_APODERADO = 1
  enum role: { supervisor: self::ROL_SUPERVISOR, apoderado: self::ROL_APODERADO }

  scope :supervisor, ->(role) { where(role: :supervisor) }
  scope :apoderado, ->(role) { where(role: :apoderado) }
end
