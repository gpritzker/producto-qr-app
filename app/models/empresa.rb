class Empresa < ApplicationRecord
  # Relaciones
  belongs_to :admin_user, class_name: 'User', foreign_key: 'admin_user_id'
  has_many :products
  has_many :declaraciones_conformidad, through: :products
  has_many :delegaciones
  has_many :delegated_users, through: :delegaciones, source: :user

  # Validaciones
  validates :razon_social, :CUIT, :domicilio_legal, presence: true
end
