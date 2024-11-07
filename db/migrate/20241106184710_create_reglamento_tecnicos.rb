class CreateReglamentoTecnicos < ActiveRecord::Migration[7.0]
  def change
    create_table :reglamento_tecnicos do |t|
      t.string :nombre

      t.timestamps
    end

    add_index :reglamento_tecnicos, :nombre, unique: true
  end
end
