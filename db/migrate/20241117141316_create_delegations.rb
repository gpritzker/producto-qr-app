class CreateDelegations < ActiveRecord::Migration[7.0]
  def change
    create_table :delegations do |t|
      t.references :company
      t.string :email, null: false
      t.integer :status, :null => false, :default => 0
      t.integer :role, :null => false, :default => 0
      t.timestamps
    end

    add_reference :delegations, :creator, null: false, foreign_key: { to_table: :users }
  end
end
