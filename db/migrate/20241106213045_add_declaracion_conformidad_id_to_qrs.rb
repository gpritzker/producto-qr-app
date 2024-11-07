class AddDeclaracionConformidadIdToQrs < ActiveRecord::Migration[7.0]
  def change
    add_column :qrs, :declaracion_conformidad_id, :integer
    add_index :qrs, :declaracion_conformidad_id
    add_foreign_key :qrs, :declaracion_conformidads
  end
end