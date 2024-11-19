class Authorization < ApplicationRecord
  has_one_attached :authorization_file, service: :authorizations

  belongs_to :company
  belongs_to :user

  validates :authorization_file,
            presence: { message: "El archivo de autorización es obligatorio." },
            content_type: { in: ['application/pdf'], message: "Solo se permiten archivos PDF." },
            size: { less_than: 5.megabytes, message: "El archivo de autorización no puede exceder los 5 MB." }

  validates :user_id, uniqueness: { scope: :company_id }
end
