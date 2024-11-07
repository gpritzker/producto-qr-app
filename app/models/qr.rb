class Qr < ApplicationRecord
  belongs_to :declaracion_conformidad

  # Validaciones
  validates :url_destino, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "debe ser una URL válida" }
end
