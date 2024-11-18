class CreateQrs < ActiveRecord::Migration[7.0]
  def change
    create_table :qrs do |t|
      t.references :company
      t.references :user
      t.string :code, :null => false
      t.string :description, :null => false
      t.string :alias, :null => false
      t.string :origin, :null => false

      t.timestamps
    end
  end
end
