class Qr < ApplicationRecord
  belongs_to :company
  
  # Validaciones
  validates :code, presence: true
  validates :description, presence: true
  validates :alias, presence: true
  validates :origin, presence: true

  before_validation :generate_code, :normalize_attributes

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
end
