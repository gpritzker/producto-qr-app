class DeclaracionConformidad < ApplicationRecord
  belongs_to :product
  belongs_to :empresa
  belongs_to :reglamento_tecnico
  belongs_to :tipo_procedimiento

  has_many :documento_soportes, dependent: :destroy
  has_one :qr, dependent: :destroy

  # Validaciones
  validates :numero_reporte, :emisor_reporte, :fecha_emision, presence: true
  validates :descripcion_producto, presence: true, if: -> { product.new_record? }  # Solo requerido si es un nuevo producto
  validates :origen, presence: true, if: -> { product.new_record? }               # Solo requerido si es un nuevo producto
  validates :estado, presence: true

  # Enum para el estado de la declaración
  enum estado: { activa: 0, suspendida: 1 }

  # Generar el QR vinculado a esta declaración
  after_create :generate_qr_code

  private

  def generate_qr_code
    qr_code = Qr.create(
      declaracion_conformidad: self,
      url_destino: Rails.application.routes.url_helpers.declaracion_conformidad_url(self, host: Rails.env.production? ? "https://miapp.com" : "http://localhost:3000")
    )
    qr_code.save
  end
end
