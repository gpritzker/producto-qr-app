class CreateDjcs < ActiveRecord::Migration[7.0]
  def change
    create_table :djcs do |t|
      t.references :company, null: false, foreign_key: true
      t.references :qr, null: false, foreign_key: true
      t.references :tipo_procedimiento, null: false, foreign_key: true
      t.references :reglamento_tecnico, null: false, foreign_key: true
      
      t.string :product_description, null: false
      t.string :legal_address, null: false
      t.string :deposit_address, null: false
      t.string :manufacturer, null: false

      t.jsonb :product_attributes, null: false, default: []
      t.jsonb :reports, null: false, default: []

      t.boolean :approved, :null => false, default: false
      t.boolean :signed, :null => false, default: false  
      
      t.datetime :approved_at, :null => true
      t.datetime :signed_at, :null => true

      t.timestamps
    end

    add_reference :djcs, :signed_by, foreign_key: { to_table: :users }, null: true
    add_reference :djcs, :approved_by, foreign_key: { to_table: :users }, null: true
  end
end
