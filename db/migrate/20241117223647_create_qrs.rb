class CreateQrs < ActiveRecord::Migration[7.0]
  def change
    create_table :qrs do |t|
      t.string :code, :null => false
      t.string :descripcion, :null => false
      t.string :alias, :null => false
      t.string :origen, :null => false

      t.timestamps
    end
  end
end
