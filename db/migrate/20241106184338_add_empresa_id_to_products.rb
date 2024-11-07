class AddEmpresaIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :empresa_id, :integer
    add_index :products, :empresa_id
  end
end
