class Qr < ApplicationRecord
  has_one_attached :qr_image, service: :qrs
  has_one_attached :qr_small_image, service: :qrs

  belongs_to :company
  has_many :djcs
  
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
  before_create :generate_images

  def url
    ENV['QR_DOMAIN']+self.code
  end

  def generate_svg_big
    RQRCode::QRCode.new(url).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      border_modules: 0, # borde del QR
      module_size: 3.62
    )
  end

  def generate_svg_small
    RQRCode::QRCode.new(url).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      border_modules: 0, # borde del QR
      module_size: 1.43
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

  def generate_images
    # 1. Generar el QR con RQRCode
    qr_code = RQRCode::QRCode.new(url)

    images = [
      # nombre, pixeles, base_image_name
      ["big", 119, "qr_big.png",'+15+13'],
      ["small", 49, "qr_small.png",'+9+9']
    ]
    images.each do |image|
      # 2. Convertir el QR a una imagen PNG
      png = qr_code.as_png(
        resize_gte_to: false,
        resize_exactly_to: true,
        fill: 'white',
        color: 'black',
        size: image[1], # tamaño en píxeles
        border_modules: 0, # borde del QR
        module_px_size: 6 # tamaño del módulo
      )

      # 3. Guardar temporalmente el PNG
      temp_file = Tempfile.new(['qr_code', '.png'])
      temp_file.binmode
      temp_file.write(png.to_s)
      temp_file.rewind

      # 4. Superponer el QR en la imagen base
      base_image_path = Rails.root.join("app", "assets", "images", image[2])
      final_image = Tempfile.new(['final_image', '.png'])

      MiniMagick::Tool::Composite.new do |composite|
        composite.gravity 'NorthWest'   # Posición del QR (puedes cambiarlo: NorthWest, Center, etc.)
        composite.geometry image[3]     # Ajusta desplazamiento en X (+50) e Y (+50)
        composite << temp_file.path     # QR (superior)
        composite << base_image_path    # Imagen base (inferior)
        composite << final_image.path   # Resultado final
      end

      # 5. Enviar la imagen como descarga
      #send_data File.read(final_image.path), type: 'image/png', filename: 'final_image.png'
      # 5. Adjuntar al modelo
      if image[0] == "big"
        self.qr_image.attach(
          io: File.open(final_image.path),
          filename: 'final_image.png',
          content_type: 'image/png'
        )
      else
        self.qr_small_image.attach(
          io: File.open(final_image.path),
          filename: 'final_image.png',
          content_type: 'image/png'
        )
      end

      # Opcional: Limpiar archivos temporales
      temp_file.close!
      temp_file.unlink
      final_image.close!
      final_image.unlink
    end
  end
end

