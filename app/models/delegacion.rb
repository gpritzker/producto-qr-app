class Delegacion < ApplicationRecord
  belongs_to :empresa
  belongs_to :usuario_origen, class_name: "User", foreign_key: "usuario_origen_id"
  belongs_to :usuario_destino, class_name: "User", foreign_key: "usuario_destino_id"
end
