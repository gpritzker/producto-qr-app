class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relaciones
  has_many :products, dependent: :destroy
  has_many :empresas, foreign_key: :admin_user_id, dependent: :destroy
  has_many :delegaciones_enviadas, class_name: "Delegacion", foreign_key: "usuario_origen_id", dependent: :destroy
  has_many :delegaciones_recibidas, class_name: "Delegacion", foreign_key: "usuario_destino_id", dependent: :destroy
  has_many :empresas_autorizadas, through: :delegaciones_recibidas, source: :empresa

  # Validaciones
  validates :email, presence: true, uniqueness: true
end