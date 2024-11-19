class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.integer :rol, :null => false
      t.timestamps
    end

    add_index :roles, [:user_id, :company_id, :rol], unique: true
  end
end
