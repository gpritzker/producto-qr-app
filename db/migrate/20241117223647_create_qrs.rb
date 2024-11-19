class CreateQrs < ActiveRecord::Migration[7.0]
  def change
    create_table :qrs do |t|
      t.references :company
      t.string :code, :limit => 20, :null => false
      t.string :description, :null => false
      t.string :alias, :limit => 50, :null => false
      t.string :origin, :limit => 50, :null => false
      t.boolean :active, :null => false, default: false
      t.timestamps
    end
  end
end
