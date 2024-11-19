class AddUniqueIndexToRoles < ActiveRecord::Migration[7.0]
  def change
    add_index :roles, [:user_id, :company_id], unique: true
  end
end
