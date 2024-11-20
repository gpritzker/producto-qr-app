class ReglamentoTecnico < ApplicationRecord
  # Relaciones
  has_many :djcs

  # Validaciones
  validates :nombre, presence: true, uniqueness: true
end
