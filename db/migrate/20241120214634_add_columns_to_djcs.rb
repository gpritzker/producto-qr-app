class AddColumnsToDjcs < ActiveRecord::Migration[7.0]
  def change
    add_column :djcs, :trade_mark, :string, :limit => 50, :null => false
    add_column :djcs, :manufacturer_address, :string, :null => false
    add_column :djcs, :technical_normatives, :string, array: true, default: []    
  end
end
