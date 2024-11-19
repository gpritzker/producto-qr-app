class Company < ApplicationRecord
  has_one_attached :estatuto_file, service: :estatutos

  validates :cuit,
            presence: { message: "El CUIT es obligatorio" },
            format: { with: /\A\d{2}-\d{8}-\d{1}\z/, message: "El CUIT debe tener el formato XX-XXXXXXXX-X" }
  validates :name,
            presence: { message: "El nombre es obligatorio" },
            length: { minimum: 1, maximum: 50,
              too_short: "El nombre debe tener al menos 1 carácter",
              too_long: "El nombre no puede exceder los 50 caracteres" }
  validates :address,
            presence: { message: "La dirección es obligatoria" },
            length: { minimum: 3, message: "La dirección debe tener al menos 3 caracteres" }
  validates :contact_email,
            presence: { message: "El correo de contacto es obligatorio" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'El correo de contacto debe ser un correo electrónico válido' },
            length: { minimum: 3, maximum: 250,
              too_short: "El correo de contacto debe tener al menos 3 caracteres",
              too_long: "El correo de contacto no puede exceder los 250 caracteres" }
  validates :contact_name,
            presence: { message: "El nombre de contacto es obligatorio" },
            length: { minimum: 3, maximum: 50,
              too_short: "El nombre de contacto debe tener al menos 3 caracteres",
              too_long: "El nombre de contacto no puede exceder los 50 caracteres" }
  validates :contact_phone,
            presence: { message: "El teléfono de contacto es obligatorio" },
            format: { with: /\A\d{8,50}\z/, message: "El número de teléfono debe tener más de 7 dígitos" }
  validates :estatuto_file,
            content_type: { in: ['application/pdf'], message: "Solo se permiten archivos PDF." },
            size: { less_than: 12.megabytes, message: "El archivo no puede exceder los 12 MB" },
            if: -> { estatuto_file.present? }

  has_many :delegations
  has_many :roles
  has_many :authorizations
  has_many :qrs
  has_many :users, through: :roles

  before_validation :normalize_attributes

  def verificable?
    estatuto_file.attached?
  end

  private

  def normalize_attributes
    self.name = name.upcase.strip unless name.nil?
    self.contact_email = contact_email.downcase.strip unless contact_email.nil?
    self.contact_name = contact_name.upcase.strip unless contact_name.nil?
    self.contact_phone = contact_phone.strip unless contact_phone.nil?
    self.address = address.strip unless address.nil?
    self.cuit = cuit.strip unless cuit.nil?
  end
end
