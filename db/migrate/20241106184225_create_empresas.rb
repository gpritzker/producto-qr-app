class CreateEmpresas < ActiveRecord::Migration[7.0]
  def change
    create_table :empresas do |t|
      t.string :razon_social
      t.string :CUIT
      t.string :domicilio_legal
      t.integer :estado
      t.string :apoderado_nombre
      t.string :apoderado_CUIL
      t.string :apoderado_cargo
      t.string :apoderado_contacto

      t.timestamps
    end
    add_index :empresas, :CUIT, unique: true
  end
end