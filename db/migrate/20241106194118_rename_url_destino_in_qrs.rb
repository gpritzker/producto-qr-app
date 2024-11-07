class RenameUrlDestinoInQrs < ActiveRecord::Migration[7.0]
  def change
    rename_column :qrs, :URL_destino, :url_destino
  end
end
