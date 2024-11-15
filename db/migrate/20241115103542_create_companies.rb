class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, :null => false, limit: 50
      t.string :cuit, :null => false, limit: 20
      t.string :address, :null => false
      t.string :contact_name, limit: 50, :null => true, default: null
      t.string :contact_phone, limit: 50, :null => true, default: null
      t.string :contact_email, :null => true, default: null
      t.integer :status
      t.references :user, foreign_key: true, column: :creator_id
      t.timestamps
    end
    add_index :companies, :cuit, unique: true
  end
end
