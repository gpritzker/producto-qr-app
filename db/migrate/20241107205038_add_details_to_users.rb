class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nombre_completo, :string
    add_column :users, :empresa, :string
    add_column :users, :cargo, :string
    add_column :users, :telefono, :string
  end
end