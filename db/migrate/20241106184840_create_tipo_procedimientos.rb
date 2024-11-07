class CreateTipoProcedimientos < ActiveRecord::Migration[7.0]
  def change
    create_table :tipo_procedimientos do |t|
      t.string :nombre

      t.timestamps
    end

    add_index :tipo_procedimientos, :nombre, unique: true
  end
end

