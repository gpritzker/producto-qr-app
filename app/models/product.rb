class Product < ApplicationRecord
  belongs_to :user # Relación con usuario
  belongs_to :empresa
  has_many :declaraciones_conformidad
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true

  def generate_qr_code
    qrcode = RQRCode::QRCode.new(Rails.application.routes.url_helpers.product_url(self, host: "localhost:3000"))
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6
    )
  end
end
