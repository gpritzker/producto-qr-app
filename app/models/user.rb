class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many_attached :dni_files, service: :dnis
  has_one_attached :signature_file, service: :signatures

  # Relaciones
  has_many :companies, foreign_key: :creator_id, dependent: :destroy
  has_many :roles
  has_many :authorizations
  has_many :delegations, foreign_key: :creator_id, dependent: :destroy
  has_many :qrs, dependent: :destroy
  # has_many :empresas, foreign_key: :admin_user_id, dependent: :destroy
  # has_many :delegaciones_enviadas, class_name: "Delegacion", foreign_key: "usuario_origen_id", dependent: :destroy
  # has_many :delegaciones_recibidas, class_name: "Delegacion", foreign_key: "usuario_destino_id", dependent: :destroy
  # has_many :empresas_autorizadas, through: :delegaciones_recibidas, source: :empresa

  # Validaciones
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: {minimum:5}
  validates :phone, 
            presence: true,
            format: { with: /\A\d{8,50}\z/, 
            message: "El número de teléfono debe tener mas de 7 dígitos" }
  validates :bussiness, presence: true, length: {minimum:5}
  validates :position, presence: true, length: {minimum:5}
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
  
  # Normalizaciones
  before_validation :normalize_attributes

  def can_by_supervisor?
    return true if !cuil.nil? && dni_files.attached?
    false
  end

  def can_by_apoderado?
    return true if can_by_supervisor? && signature_file.attached?
    false
  end

  private

  def normalize_attributes
    self.name = name.upcase.strip unless name.nil?
    self.email = email.downcase.strip unless email.nil?
  end
end