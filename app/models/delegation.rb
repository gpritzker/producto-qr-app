class Delegation < ApplicationRecord
  belongs_to :company
  
  enum role: {delegado: Role::ROL_DELEGADO, supervisor: Role::ROL_SUPERVISOR, apoderado: Role::ROL_APODERADO }
  
  validates :email, 
            presence: { message: 'El campo de correo electrónico no puede estar vacío.' },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'El correo electrónico ingresado no es válido.' },
            length: { minimum: 3, maximum: 250, 
                      too_short: 'El correo electrónico debe tener al menos 3 caracteres.',
                      too_long: 'El correo electrónico no puede exceder los 250 caracteres.' }

  scope :with_email, -> (email) { where(email: email) }

  # Normalizaciones
  before_validation :normalize_attributes

  private

  def normalize_attributes
    self.email = email.downcase.strip unless self.email.nil?
  end
end
