class Company < ApplicationRecord
  attr_accessor :name, :cuit, :address, :contact_name, :contact_phone, :contact_email

  has_many :roles

  validates :cuit, 
            format: { with: /\A\d{2}-\d{8}-\d{1}\z/, message: "El CUIT debe tener el formato XX-XXXXXXXX-X" }
  validates :name, presence: true, length: {minimum:3, maximum:50}
  validates :contact_email, 
            format: { with: URI::MailTo::EMAIL_REGEXP }, 
            length: {minimum:3, maximum:250}
            email: { message: 'El correo de contacto debe ser un correo electrónico válido' }
            if: :contact_email?
  validates :contact_name, length: {minimum:3, maximum:50}, if: :contact_name?
  validates :contact_phone,
            format: { with: /\A\d{8,50}\z/, 
            message: "El número de teléfono debe tener mas de 7 dígitos" }, 
            if: :contact_phone?

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :apoderados, class_name: 'User', through: :roles, conditions: {roles: {role: 0}}
end
