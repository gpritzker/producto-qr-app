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

<<<<<<< Updated upstream
ActiveRecord::Schema[7.0].define(version: 2024_11_23_143653) do
=======
ActiveRecord::Schema[7.0].define(version: 2024_11_20_214634) do
>>>>>>> Stashed changes
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authorizations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_authorizations_on_company_id"
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "cuit", limit: 20, null: false
    t.string "address", null: false
    t.string "contact_name", limit: 50, null: false
    t.string "contact_phone", limit: 50, null: false
    t.string "contact_email", null: false
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delegations", force: :cascade do |t|
    t.bigint "company_id"
    t.string "email", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_delegations_on_company_id"
    t.index ["email", "company_id"], name: "index_delegations_on_email_and_company_id", unique: true
  end

  create_table "djcs", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "qr_id", null: false
    t.bigint "tipo_procedimiento_id", null: false
    t.bigint "reglamento_tecnico_id", null: false
    t.string "product_description", null: false
    t.string "legal_address", null: false
    t.string "deposit_address", null: false
    t.string "manufacturer", null: false
    t.jsonb "product_attributes", default: [], null: false
    t.jsonb "reports", default: [], null: false
    t.boolean "approved", default: false, null: false
    t.boolean "signed", default: false, null: false
    t.datetime "approved_at"
    t.datetime "signed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "signed_by_id"
    t.bigint "approved_by_id"
    t.bigint "creator_id"
    t.string "bussiness_name", limit: 50, null: false
    t.string "trade_mark", limit: 50, null: false
    t.string "manufacturer_address", null: false
    t.string "technical_normatives", default: [], array: true
    t.index ["approved_by_id"], name: "index_djcs_on_approved_by_id"
    t.index ["company_id"], name: "index_djcs_on_company_id"
    t.index ["creator_id"], name: "index_djcs_on_creator_id"
    t.index ["qr_id"], name: "index_djcs_on_qr_id"
    t.index ["reglamento_tecnico_id"], name: "index_djcs_on_reglamento_tecnico_id"
    t.index ["signed_by_id"], name: "index_djcs_on_signed_by_id"
    t.index ["tipo_procedimiento_id"], name: "index_djcs_on_tipo_procedimiento_id"
  end

  create_table "qrs", force: :cascade do |t|
    t.bigint "company_id"
    t.string "code", limit: 20, null: false
    t.string "description", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_qrs_on_company_id"
  end

  create_table "reglamento_tecnicos", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_reglamento_tecnicos_on_nombre", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "user_id"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_roles_on_company_id"
    t.index ["user_id", "company_id"], name: "index_roles_on_user_id_and_company_id", unique: true
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "tipo_procedimientos", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_tipo_procedimientos_on_nombre", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "bussiness", null: false
    t.string "position", null: false
    t.string "phone", limit: 20, null: false
    t.string "cuil", limit: 20
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "djcs", "companies"
  add_foreign_key "djcs", "qrs"
  add_foreign_key "djcs", "reglamento_tecnicos"
  add_foreign_key "djcs", "tipo_procedimientos"
  add_foreign_key "djcs", "users", column: "approved_by_id"
  add_foreign_key "djcs", "users", column: "creator_id"
  add_foreign_key "djcs", "users", column: "signed_by_id"
end
