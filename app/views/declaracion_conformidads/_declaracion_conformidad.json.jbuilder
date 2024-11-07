json.extract! declaracion_conformidad, :id, :producto_id, :reglamento_tecnico_id, :tipo_procedimiento_id, :numero_reporte, :emisor_reporte, :fecha_emision, :estado, :created_at, :updated_at
json.url declaracion_conformidad_url(declaracion_conformidad, format: :json)
