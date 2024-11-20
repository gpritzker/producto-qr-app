class TipoProcedimiento < ApplicationRecord
  has_many :djcs

  # Validaciones
  validates :nombre, presence: true, uniqueness: true
end