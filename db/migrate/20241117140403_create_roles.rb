class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.references :company
      t.references :user
      t.integer :role, :null => false, default: 0
      t.timestamps
    end
  end
end
