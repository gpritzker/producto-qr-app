class Company < ApplicationRecord
  has_one_attached :estatuto_file, service: :estatutos

  validates :cuit, 
            presence: true,
            format: { with: /\A\d{2}-\d{8}-\d{1}\z/, message: "El CUIT debe tener el formato XX-XXXXXXXX-X" }
  validates :name, presence: true, length: {minimum:3, maximum:50}
  validates :address, presence: true, length: {minimum:3}
  validates :contact_email, 
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'El correo de contacto debe ser un correo electrónico válido' }, 
            length: {minimum:3, maximum:250}
  validates :contact_name, 
            presence: true,
            length: {minimum:3, maximum:50}          
  validates :contact_phone,
            presence: true,
            format: { with: /\A\d{8,50}\z/, message: "El número de teléfono debe tener mas de 7 dígitos" }
  validates :estatuto_file, 
            content_type: ['application/pdf'], 
            size: { less_than: 5.megabytes }, 
            if: -> { estatuto_file.present? }

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :delegations
  has_many :roles
  has_many :authorizations

  accepts_nested_attributes_for :delegations

  # Normalizaciones
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
