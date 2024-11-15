class CreateQrs < ActiveRecord::Migration[7.0]
  def change
    create_table :qrs do |t|
      t.string :URL_destino
      t.integer :estado

      t.timestamps
    end
  end
end
