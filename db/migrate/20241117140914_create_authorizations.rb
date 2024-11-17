class CreateAuthorizations < ActiveRecord::Migration[7.0]
  def change
    create_table :authorizations do |t|
      t.references :user
      t.references :company
      t.timestamps
    end
  end
end
