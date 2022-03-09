# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_25_095302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_data", force: :cascade do |t|
    t.string "key", null: false
    t.binary "io", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_active_storage_data_on_key"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key"
    t.string "title", null: false
    t.text "descr"
    t.integer "position"
    t.boolean "active", default: false
    t.index ["key"], name: "index_categories_on_key", unique: true
  end

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "doctype"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.string "comments"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "request_id"
    t.string "message"
    t.integer "status", default: 0, null: false
    t.integer "source"
    t.boolean "sendmail", default: false, null: false
    t.string "notification_type", default: "notice", null: false
    t.string "notification_url"
    t.string "string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_notifications_on_request_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 2, null: false
  end

  create_table "site_infos", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "key", null: false
    t.text "value"
    t.string "icon_class"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_site_infos_on_key", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "fullname"
    t.string "address"
    t.string "cap"
    t.string "city"
    t.string "prov"
    t.string "phone"
    t.string "vatcode"
    t.string "description"
    t.uuid "category_id"
    t.uuid "service_id"
    t.integer "usertype", default: 0
    t.string "language", default: "it", null: false
    t.boolean "edited", default: false, null: false
    t.boolean "docsuploaded", default: false, null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.integer "credits_total", default: 0
    t.boolean "privacy", default: true, null: false
    t.boolean "marketing", default: true, null: false
    t.boolean "profiling", default: true, null: false
    t.string "public_email"
    t.string "public_phone"
    t.string "public_website"
    t.text "public_description"
    t.string "ragionesociale"
    t.string "public_ragionesociale"
    t.string "public_url"
    t.boolean "test_user", default: false, null: false
    t.json "subscription_data"
    t.string "public_address"
    t.string "public_city"
    t.string "public_prov"
    t.string "public_certified", default: "f", null: false
    t.string "public_hours"
    t.string "public_facebook"
    t.string "public_instagram"
    t.string "public_linkedin"
    t.string "public_youtube"
    t.string "public_bkground"
    t.index ["category_id"], name: "index_users_on_category_id"
    t.index ["city"], name: "index_users_on_city"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["fullname"], name: "index_users_on_fullname"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["prov"], name: "index_users_on_prov"
    t.index ["public_url"], name: "index_public_url", unique: true
    t.index ["ragionesociale", "prov"], name: "index_ragionesociale_prov_unique", unique: true
    t.index ["ragionesociale"], name: "index_ragionesociale"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["service_id"], name: "index_users_on_service_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
