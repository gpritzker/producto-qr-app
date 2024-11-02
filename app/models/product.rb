class Product < ApplicationRecord
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
