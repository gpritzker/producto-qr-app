class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, :limit => 50, :null => false
      t.string :bussiness, :null => true, default: null
      t.string :position, :null => true, default: null
      t.string :phone, limit: 50, :null => true, default: null

      # Campos para devise
      t.string :email,              null: false
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.boolean :admin, default: false      
      t.timestamps     # Añade las columnas created_at y updated_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end