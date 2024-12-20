class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many_attached :dni_files
  has_one_attached :signature_file
  has_many :versions, foreign_key: :whodunnit

  # Relaciones
  has_many :roles
  has_many :authorizations
  has_many :delegations, foreign_key: :email
  has_many :companies, through: :roles

  scope :companies_with_role, -> (user_id) { 
    Company
    .joins(roles: :user)
    .where(users: { id: user_id })
    .select('companies.*, roles.role AS user_role')
  }
  scope :djcs_with_role, -> (user_id) {
    Djc.joins(company: { roles: :user })
   .where(roles: { user_id: user_id })
   .select('djcs.*, roles.role AS user_role')
  }

  # Validaciones
  validates :email, 
            presence: { message: "El email es obligatorio" },
            uniqueness: { message: "Este email ya está registrado" }
  validates :name, 
            presence: { message: "El nombre es obligatorio" },
            length: { minimum: 5, message: "El nombre debe tener al menos 5 caracteres" }
  validates :phone, 
            presence: { message: "El teléfono es obligatorio" },
            format: { with: /\A\d{8,50}\z/, message: "El número de teléfono debe tener más de 7 dígitos" }
  validates :bussiness, 
            presence: { message: "La empresa es obligatorio" },
            length: { minimum: 2, message: "La empresa debe tener al menos 2 caracteres" }
  validates :position, 
            presence: { message: "El puesto es obligatorio" },
            length: { minimum: 2, message: "El puesto debe tener al menos 2 caracteres" }
  validates :cuil, 
            format: { with: /\A\d{2}-\d{8}-\d{1}\z/, message: "El CUIL debe tener el formato XX-XXXXXXXX-X" },
            if: -> { cuil.present? }
  validates :signature_file, 
            content_type: { in: ['image/png'], message: "Solo se permiten archivos PNG" }, 
            size: { less_than: 1.megabytes, message: "El archivo no puede superar 1MB" }, 
            if: -> { signature_file.attached? }
  validates :dni_files, 
            content_type: { in: ['image/png', 'image/jpeg'], message: "Solo se permiten archivos PNG o JPEG" }, 
            length: { is: 2, message: "Debes subir exactamente 2 archivos" }, 
            size: { less_than: 1.megabytes, message: "Cada archivo no puede superar 1MB" }, 
            if: -> { dni_files.attached? }
  
  # Validación personalizada para contraseñas seguras
  validate :secure_password
  
  # Normalizaciones
  before_validation :normalize_attributes

  def can_by_apoderado?
    return true if !cuil.nil? && signature_file.attached?
    false
  end

  def generate_signature_qr
    #secret_key = SecureRandom.hex(32)
    encryptor = ActiveSupport::MessageEncryptor.new([ENV['SIGNATURE_KEY']].pack("H*"))
    encrypted_message = encryptor.encrypt_and_sign({user_id: id, valid_until: Time.now + 1.hour}.to_json)

    RQRCode::QRCode.new(ENV['SIGNATURE_DOMAIN'] + encrypted_message).as_svg(
      viewbox: true,
      use_path: true,
      standalone: false,
      border_modules: 0, # borde del QR
      module_size: 1 # tamaño del módulo
    )
  end

  private

  def normalize_attributes
    self.name = name.upcase.strip unless name.nil?
    self.email = email.downcase.strip unless email.nil?
  end

  # Validación para contraseñas seguras
  def secure_password
    return if password.blank?

    unless password.match?(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/)
      errors.add(:password, 'debe tener al menos una letra mayúscula, una letra minúscula, un número y tener al menos 8 caracteres.')
    end
  end
  
end