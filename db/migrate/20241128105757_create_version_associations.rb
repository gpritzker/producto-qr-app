class CreateVersionAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :version_associations do |t|
      t.bigint :version_id, null: false
      t.bigint :foreign_key_id, null: false
      t.string :foreign_key_name, null: false

      t.timestamps
    end

    add_index :version_associations, [:version_id]
    add_index :version_associations, [:foreign_key_name, :foreign_key_id], name: 'index_version_associations_on_foreign_key'
  end
end
