class UpdateDeclaracionConformidadFields < ActiveRecord::Migration[7.0]
  def change
    # Cambiar la referencia de `products` a `product`
    remove_reference :declaracion_conformidads, :products, foreign_key: true
    add_reference :declaracion_conformidads, :product, foreign_key: true, null: false

    # Agregar referencia a `empresa`
    add_reference :declaracion_conformidads, :empresa, foreign_key: true

    # Agregar campos `descripcion_producto` y `origen`
    add_column :declaracion_conformidads, :descripcion_producto, :text
    add_column :declaracion_conformidads, :origen, :string

    # Modificar el campo `estado` para que tenga un valor predeterminado
    change_column_default :declaracion_conformidads, :estado, from: nil, to: 0
  end
end