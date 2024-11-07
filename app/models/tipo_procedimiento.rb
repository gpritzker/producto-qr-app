class TipoProcedimiento < ApplicationRecord
  # Relaciones
  has_many :declaraciones_conformidad

  # Validaciones
  validates :nombre, presence: true, uniqueness: true
end