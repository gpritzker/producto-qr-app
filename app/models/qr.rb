class Qr < ApplicationRecord
  has_one_attached :qr_image, service: :qrs
  has_one_attached :qr_small_image, service: :qrs

  belongs_to :company
  has_many :djcs
  
  # Validaciones
  validates :code, presence: true
  validates :description, presence: true
  validates :alias, presence: true
  validates :origin, presence: true

  before_validation :generate_code, :normalize_attributes
  before_create :generate_images

  def url
    ENV['QR_DOMAIN']+self.code
  end

  private 

  def normalize_attributes
    self.description = description.downcase.strip unless description.nil?
    self.alias = self.alias.strip unless self.alias.nil?
    self.origin = origin.strip unless origin.nil?
  end

  def generate_code
    if self.code.nil?
      data = "#{Time.now.to_i}#{self.description}#{self.alias}"
      self.code = Digest::SHA256.new.update(data).hexdigest.slice(1,10)
    end
  end

  def generate_images
    # 1. Generar el QR con RQRCode
    qr_code = RQRCode::QRCode.new(url)

    # 2. Convertir el QR a una imagen PNG
    png = qr_code.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 300, # tamaño en píxeles
      border_modules: 1, # borde del QR
      module_px_size: 6 # tamaño del módulo
    )

    # 3. Guardar temporalmente el PNG
    temp_file = Tempfile.new(['qr_code', '.png'])
    temp_file.binmode
    temp_file.write(png.to_s)
    temp_file.rewind

    # 4. Redimensionar a 20mm x 20mm (≈ 236px x 236px a 300 DPI)
    resized_file = Tempfile.new(['resized_qr_code', '.png'])
    resized_small_file = Tempfile.new(['resized_small_qr_code', '.png'])
    MiniMagick::Image.new(temp_file.path).tap do |image|
      image.resize '236x236!'  # Use "!" to resize with exact dimensions
      image.write resized_file.path
    end
    MiniMagick::Image.new(temp_file.path).tap do |image|
      image.resize '94x94!'  # Use "!" to resize with exact dimensions
      image.write resized_small_file.path
    end

    # 5. Adjuntar al modelo QR
    self.qr_image.attach(
      io: File.open(resized_file.path),
      filename: 'qr_code.png',
      content_type: 'image/png'
    )
    self.qr_small_image.attach(
      io: File.open(resized_small_file.path),
      filename: 'qr_code.png',
      content_type: 'image/png'
    )

    # 6. Limpiar archivos temporales
    temp_file.close
    temp_file.unlink
    resized_file.close
    resized_file.unlink
    resized_small_file.close
    resized_small_file.unlink
  end
end