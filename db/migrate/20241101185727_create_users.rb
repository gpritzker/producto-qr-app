class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name   # Puedes añadir campos adicionales según tus necesidades
      t.timestamps     # Añade las columnas created_at y updated_at
    end
  end
end