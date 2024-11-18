class Delegation < ApplicationRecord
  enum status: { waiting: 0, accepted: 1, rejected: 2 }

  belongs_to :company
  has_one :authorization
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :status, inclusion: { in: statuses.keys }
  validates :email, 
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'El correo al cual delegar debe ser un correo electrónico válido' }, 
            length: {minimum:3, maximum:250}
  validates :role, inclusion: { in: Role::roles.values }

  scope :as_supervisor, -> { where(role: Role::ROL_SUPERVISOR) }
  scope :as_apoderado, -> { where(role: Role::ROL_APODERADO) }
  scope :with_email, -> (email) { where(email: email) }

  # Normalizaciones
  before_validation :normalize_attributes

  accepts_nested_attributes_for :authorization

  private

  def normalize_attributes
    self.email = email.downcase.strip unless email.nil?
  end
end
