class AddAdminUserIdToEmpresas < ActiveRecord::Migration[7.0]
  def change
    add_column :empresas, :admin_user_id, :integer
    add_index :empresas, :admin_user_id
  end
end
