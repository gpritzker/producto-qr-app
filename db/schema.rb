# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_11_07_205038) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "declaracion_conformidads", force: :cascade do |t|
    t.bigint "reglamento_tecnico_id"
    t.bigint "tipo_procedimiento_id"
    t.string "numero_reporte"
    t.string "emisor_reporte"
    t.date "fecha_emision"
    t.integer "estado", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.bigint "empresa_id"
    t.text "descripcion_producto"
    t.string "origen"
    t.index ["empresa_id"], name: "index_declaracion_conformidads_on_empresa_id"
    t.index ["product_id"], name: "index_declaracion_conformidads_on_product_id"
    t.index ["reglamento_tecnico_id"], name: "index_declaracion_conformidads_on_reglamento_tecnico_id"
    t.index ["tipo_procedimiento_id"], name: "index_declaracion_conformidads_on_tipo_procedimiento_id"
  end

  create_table "delegacions", force: :cascade do |t|
    t.bigint "empresa_id"
    t.integer "usuario_origen_id"
    t.integer "usuario_destino_id"
    t.boolean "permisos_delegacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["empresa_id"], name: "index_delegacions_on_empresa_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.string "razon_social"
    t.string "CUIT"
    t.string "domicilio_legal"
    t.integer "estado"
    t.string "apoderado_nombre"
    t.string "apoderado_CUIL"
    t.string "apoderado_cargo"
    t.string "apoderado_contacto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_user_id"
    t.string "contact_phone"
    t.string "contact_email"
    t.index ["CUIT"], name: "index_empresas_on_CUIT", unique: true
    t.index ["admin_user_id"], name: "index_empresas_on_admin_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "empresa_id"
    t.index ["empresa_id"], name: "index_products_on_empresa_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "qrs", force: :cascade do |t|
    t.string "url_destino"
    t.integer "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "declaracion_conformidad_id"
    t.index ["declaracion_conformidad_id"], name: "index_qrs_on_declaracion_conformidad_id"
  end

  create_table "reglamento_tecnicos", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_reglamento_tecnicos_on_nombre", unique: true
  end

  create_table "tipo_procedimientos", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_tipo_procedimientos_on_nombre", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.string "nombre_completo"
    t.string "empresa"
    t.string "cargo"
    t.string "telefono"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "declaracion_conformidads", "empresas"
  add_foreign_key "declaracion_conformidads", "products"
  add_foreign_key "declaracion_conformidads", "reglamento_tecnicos"
  add_foreign_key "declaracion_conformidads", "tipo_procedimientos"
  add_foreign_key "delegacions", "empresas"
  add_foreign_key "qrs", "declaracion_conformidads"
end
