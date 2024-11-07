json.extract! delegacion, :id, :empresa_id, :usuario_origen_id, :usuario_destino_id, :permisos_delegacion, :created_at, :updated_at
json.url delegacion_url(delegacion, format: :json)
