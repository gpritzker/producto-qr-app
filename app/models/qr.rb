class Qr < ApplicationRecord
  belongs_to :company
  belongs_to :user
  
  # Validaciones
  # validates :url_destino, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "debe ser una URL válida" }
  validates :code, presence: true
  validates :description, presence: true
  validates :alias, presence: true
  validates :origin, presence: true

  # Normalizaciones
  before_validation :normalize_attributes, :generate_code

  private 

  def normalize_attributes
    self.description = description.downcase.strip unless description.nil?
    self.alias = self.alias.strip unless self.alias.nil?
    self.origin = origin.strip unless origin.nil?
  end

  def generate_code
    data = "#{Time.now.to_i}#{self.description}#{self.alias}"
    self.code = Digest::SHA256.new.update(data).hexdigest.slice(1,10)
  end
end
