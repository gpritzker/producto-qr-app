class AddUniqueIndexToDelegations < ActiveRecord::Migration[7.0]
  def change
    add_index :delegations, [:email, :company_id], unique: true
  end
end
