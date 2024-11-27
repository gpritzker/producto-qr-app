class Qr < ApplicationRecord
  belongs_to :company
  has_many :djcs, dependent: :destroy
  
  # Validaciones
  validates :code, presence: true
  validates :description, 
            presence: true, 
            length: { 
              minimum: 2, 
              maximum: 250, 
              too_short: "La descripción debe tener al menos 2 caracteres", 
              too_long: "La descripción no puede exceder los 250 caracteres" 
            }
  
  before_validation :generate_code, :normalize_attributes

  def url
    ENV['QR_DOMAIN']+self.code
  end

  def generate_svg
    RQRCode::QRCode.new(url, size: 4).as_svg(
      viewbox: true,
      use_path: true,
      standalone: false,
      border_modules: 0, # borde del QR
      module_size: 1 # tamaño del módulo
    )
  end

  private 

  def normalize_attributes
    self.description = description.downcase.strip unless description.nil?
  end

  def generate_code
    if self.code.nil?
      data = "#{Time.now.to_i}#{self.description}"
      self.code = Digest::SHA256.new.update(data).hexdigest.slice(1,10)
    end
  end
end

