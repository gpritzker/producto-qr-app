class CreateDeclaracionConformidads < ActiveRecord::Migration[7.0]
  def change
    create_table :declaracion_conformidads do |t|
      t.references :products, foreign_key: true
      t.references :reglamento_tecnico, foreign_key: true
      t.references :tipo_procedimiento, foreign_key: true
      t.string :numero_reporte
      t.string :emisor_reporte
      t.date :fecha_emision
      t.integer :estado

      t.timestamps
    end
  end
end
