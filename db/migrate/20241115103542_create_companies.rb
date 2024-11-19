class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, :null => false, limit: 50
      t.string :cuit, :null => false, limit: 20
      t.string :address, :null => false
      t.string :contact_name, limit: 50, :null => false
      t.string :contact_phone, limit: 50, :null => false
      t.string :contact_email, :null => false
      t.boolean :verified, default: false
      
      t.timestamps
    end
  end
end
