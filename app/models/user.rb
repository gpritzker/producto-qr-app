class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :email, :name, :phone, :bussiness, :position
  # Relaciones
  has_many :roles
  has_many :companies, foreign_key: :creator_id, dependent: :destroy
  # has_many :products, dependent: :destroy
  # has_many :empresas, foreign_key: :admin_user_id, dependent: :destroy
  # has_many :delegaciones_enviadas, class_name: "Delegacion", foreign_key: "usuario_origen_id", dependent: :destroy
  # has_many :delegaciones_recibidas, class_name: "Delegacion", foreign_key: "usuario_destino_id", dependent: :destroy
  # has_many :empresas_autorizadas, through: :delegaciones_recibidas, source: :empresa

  # Validaciones
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: {minimum:5}
  validates :phone, 
            format: { with: /\A\d{8,50}\z/, 
            message: "El número de teléfono debe tener mas de 7 dígitos" }, 
            if: :phone?

  
  # Normalizaciones
  before_validation :normalize_attributes

  private

  def normalize_attributes
    self.name = name.upcase.strip
    self.email = email.strip
  end
end