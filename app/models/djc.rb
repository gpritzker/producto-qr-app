class Djc < ApplicationRecord
  has_many_attached :crs_files, service: :crs

  belongs_to :company
  belongs_to :qr
  belongs_to :tipo_procedimiento
  belongs_to :reglamento_tecnico
  belongs_to :signed_by, class_name: 'User', optional: true
  belongs_to :approved_by, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User', optional: true

  validates :bussiness_name,
            presence: { message: "La razón social es obligatorio" },
            length: { minimum: 1, maximum: 50,
              too_short: "La razón social debe tener al menos 1 carácter",
              too_long: "La razón social no puede exceder los 50 caracteres" }
  validates :trade_mark,
            presence: { message: "La marca registrada es obligatoria" },
            length: { minimum: 1, maximum: 50,
              too_short: "La marca registrada debe tener al menos 1 carácter",
              too_long: "La marca registrada no puede exceder los 50 caracteres" }
  validates :manufacturer_address,
            presence: { message: "La dirección del fabricante es obligatoria" },
            length: { minimum: 1, maximum: 250,
              too_short: "La dirección del fabricante debe tener al menos 1 carácter",
              too_long: "La dirección del fabricante no puede exceder los 250 caracteres" }
  validates :product_description,
            presence: { message: "La descripción de productos es obligatorio" },
            length: { minimum: 1, maximum: 50,
              too_short: "La descripción de productos debe tener al menos 1 carácter",
              too_long: "La descripción de productos no puede exceder los 50 caracteres" }
  validates :legal_address,
            presence: { message: "La dirección legal es obligatoria" },
            length: { minimum: 3, message: "La dirección legal debe tener al menos 3 caracteres" }
  validates :deposit_address,
            presence: { message: "La dirección del depósito es obligatoria" },
            length: { minimum: 3, message: "La dirección del depósito debe tener al menos 3 caracteres" }
  validates :manufacturer,
            presence: { message: "El fabricante es obligatorio" },
            length: { minimum: 1, maximum: 50,
              too_short: "El fabricante debe tener al menos 1 carácter",
              too_long: "El fabricante no puede exceder los 50 caracteres" }
  validates :crs_files, 
            content_type: { in: ['application/pdf'], message: "Solo se permiten archivos PDF" }, 
            size: { less_than: 10.megabytes, message: "Cada archivo no puede superar 10MB" }, 
            if: -> { crs_files.attached? }
  validate :product_attributes_must_be_an_array_of_hashes # [{marca, modelo, características técnicas}, ...]
  validate :reports_must_be_an_array_of_hashes # [{número_de_reporte, emisor}, ...]
  validate :technical_normatives_must_be_an_array #[normativa, ...]

  before_validation :normalize_attributes
  after_save :generate_pdf

  def generate_pdf
    nombre = "djc-#{qr.code}-#{id}"
    # Generar el PDF como un string binario
    controller = ActionController::Base.new
    pdf_content = controller.render_to_string(
      pdf: nombre, # Nombre del archivo
      template: "djcs/show",       # Vista para el PDF
      encoding: "UTF-8",
      margin: { top: 10, bottom: 10, left: 10, right: 10 },
      locals: { djc: self },
      page_size: "A4" # Usa un tamaño de página estándar
    )
    
    # Definir el path donde se guardará el archivo
    if signed_by.present?
      file_path = Rails.root.join("public", "pdfs", "#{nombre}.pdf")
    else  
      file_path = Rails.root.join("public", "pdfs", "#{nombre}-tmp.pdf")
    end  

    # Crear el directorio si no existe
    FileUtils.mkdir_p(File.dirname(file_path))

    # Guardar el contenido del PDF en un archivo
    File.open(file_path, 'ab') do |file|
      file.write(pdf_content)
    end

    # Agrego la marca de agua
    unless signed_by.present?
      watermark_pdf_path = Rails.root.join("public", "pdfs", "watermark.pdf")
      main_pdf_path = Rails.root.join("public", "pdfs", "#{nombre}-tmp.pdf")
      output_pdf_path = Rails.root.join("public", "pdfs", "#{nombre}.pdf")
      system("rm #{output_pdf_path}")
      system("hexapdf watermark -w #{watermark_pdf_path} -t stamp #{main_pdf_path} #{output_pdf_path}")
      system("rm #{main_pdf_path}")
    end    
  end

  def can_approve?
    return true if approved_by.nil?
    false
  end

  def can_sign?
    return true if approved_by.present? && signed_by.nil?
    false
  end

  private
  
  def product_attributes_must_be_an_array_of_hashes
    unless product_attributes.is_a?(Array) && product_attributes.size.positive?
      errors.add(:product_attributes, :invalid, message: "Debe cargar al menos una marca, modelo y características técnicas")
      return false
    end  
    unless product_attributes.all? { |item| 
      if item.is_a?(Hash)
        item = item.with_indifferent_access
        return false if item[:brand].nil? || item[:brand].empty?
        return false if item[:model].nil? || item[:model].empty?
        return false if item[:characteristic].nil? || item[:characteristic].empty?
        return true
      end
      false
    }
      errors.add(:product_attributes, :invalid, message: "Verifique tener marca, modelo y característica técnica")
      return false
    end
    true
  end

  def reports_must_be_an_array_of_hashes
    unless reports.is_a?(Array) && reports.size.positive?
      errors.add(:reports, :invalid, message: "Debe cargar al menos un reporte con número y emisor")
      return false
    end  
    unless reports.all? { |item| 
      if item.is_a?(Hash)
        item = item.with_indifferent_access
        return false if item[:number].nil? || item[:number].empty?
        return false if item[:emitter].nil? || item[:emitter].empty?
        return true
      end
      false
    }
      errors.add(:reports, :invalid, message: "Verifique tener número de reporte y emisor")
      return false
    end
    true
  end

  def technical_normatives_must_be_an_array
    if !technical_normatives.is_a?(Array) || technical_normatives.size.zero?
      errors.add(:technical_normatives, :invalid, message: "Debe cargar al menos una técnica normativa")
      return false
    end  
    true
  end

  def normalize_attributes
    self.product_description = product_description.strip unless product_description.nil?
    self.legal_address = legal_address.strip unless legal_address.nil?
    self.deposit_address = deposit_address.strip unless deposit_address.nil?
    self.manufacturer = manufacturer.strip unless manufacturer.nil?
  end
end
