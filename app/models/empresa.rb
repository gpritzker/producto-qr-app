class Empresa < ApplicationRecord
  # Relaciones
  belongs_to :admin_user, class_name: 'User', foreign_key: 'admin_user_id'
  has_many :products
  has_many :declaraciones_conformidad, through: :products
  has_many :delegaciones
  has_many :delegated_users, through: :delegaciones, source: :user

  # Validaciones
  validates :razon_social, :domicilio_legal, presence: true
  validates :CUIT, format: { with: /\A\d{2}-\d{8}-\d{1}\z/, message: "El CUIT debe tener el formato XX-XXXXXXXX-X" }

  before_validation :normalize_attributes

  private

  def normalize_attributes
    self.razon_social = razon_social.stip
    self.domicilio_legal = domicilio_legal.strip
    
  end
end
