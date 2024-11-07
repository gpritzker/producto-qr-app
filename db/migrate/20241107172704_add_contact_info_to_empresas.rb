class AddContactInfoToEmpresas < ActiveRecord::Migration[7.0]
  def change
    add_column :empresas, :contact_phone, :string
    add_column :empresas, :contact_email, :string
  end
end
