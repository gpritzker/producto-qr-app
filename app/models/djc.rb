class Djc < ApplicationRecord
  has_many_attached :crs_files, service: :crs

  belongs_to :company
  belongs_to :qr
  belongs_to :tipo_procedimiento
  belongs_to :reglamento_tecnico
  belongs_to :signed_by, class_name: 'User', optional: true
  belongs_to :approved_by, class_name: 'User', optional: true

  # validates :razon_social
  # validates :marca
  # validates :manufacturer_address
  # validates :normas_tecnicas

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
  validates :cr_files, 
            content_type: { in: ['application/pdf'], message: "Solo se permiten archivos PDF" }, 
            size: { less_than: 10.megabytes, message: "Cada archivo no puede superar 10MB" }, 
            if: -> { cr_files.attached? }
  validate :product_attributes_must_be_an_array_of_hashes # [{marca, modelo, características técnicas}]
  validate :reports_must_be_an_array_of_hashes # [{número_de_reporte, emisor}]

  before_validation :normalize_attributes

  private
  
  def product_attributes_must_be_an_array_of_hashes
    unless product_attributes.is_a?(Array)
      errors.add("Debe cargar al menos una marca, modelo y características técnicas")
      return false
    end  
    unless product_attributes.all? { |item| 
      item.is_a?(Hash) &&
      (item.try(:marca).nil? || item.try(:marca).size < 1) && 
      (item.try(:modelo).nil? || item.try(:modelo).size < 1) &&
      (item.try(:cat_tec).nil? || item.try(:cat_tec).size < 1)
    }
      errors.add("Verifique tener marca, modelo y característica técnica")
      return false
    end
    true
  end

  def reports_must_be_an_array_of_hashes
    unless reports.is_a?(Array)
      errors.add("Debe cargar al menos un reporte con número y emisor")
      return false
    end  
    unless product_attributes.all? { |item| 
      item.is_a?(Hash) &&
      (item.try(:numero).nil? || item.try(:numero).size < 1) && 
      (item.try(:emisor).nil? || item.try(:emisor).size < 1)
    }
      errors.add("Verifique tener número de reporte y emisor")
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
