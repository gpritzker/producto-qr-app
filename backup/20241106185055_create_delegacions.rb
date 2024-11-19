class CreateDelegacions < ActiveRecord::Migration[7.0]
  def change
    create_table :delegacions do |t|
      t.references :empresa, foreign_key: true
      t.integer :usuario_origen_id
      t.integer :usuario_destino_id
      t.boolean :permisos_delegacion

      t.timestamps
    end
  end
end
