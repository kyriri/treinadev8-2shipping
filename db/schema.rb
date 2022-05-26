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

ActiveRecord::Schema[7.0].define(version: 2022_05_26_121733) do
  create_table "delivery_times", force: :cascade do |t|
    t.integer "max_distance_in_km"
    t.integer "delivery_time_in_buss_days"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_delivery_times_on_shipping_company_id"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "width_in_cm"
    t.integer "height_in_cm"
    t.integer "length_in_cm"
    t.float "volume_in_m3"
    t.integer "weight_in_g"
    t.integer "distance_in_km"
    t.string "pickup_address"
    t.string "delivery_address"
    t.string "delivery_recipient_name"
    t.string "delivery_recipient_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_orders", force: :cascade do |t|
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "package_id", null: false
    t.integer "shipping_company_id"
    t.index ["package_id"], name: "index_service_orders_on_package_id"
    t.index ["shipping_company_id"], name: "index_service_orders_on_shipping_company_id"
  end

  create_table "shipping_companies", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.string "legal_name"
    t.string "email_domain"
    t.integer "cnpj"
    t.string "billing_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cubic_weight_const", precision: 6, scale: 2
    t.decimal "min_fee", precision: 5, scale: 2
  end

  create_table "shipping_rates", force: :cascade do |t|
    t.integer "cost_per_km_in_cents"
    t.decimal "max_weight_in_kg", precision: 4, scale: 1
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_shipping_rates_on_shipping_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.integer "shipping_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["shipping_company_id"], name: "index_users_on_shipping_company_id"
  end

  add_foreign_key "delivery_times", "shipping_companies"
  add_foreign_key "service_orders", "packages"
  add_foreign_key "service_orders", "shipping_companies"
  add_foreign_key "shipping_rates", "shipping_companies"
  add_foreign_key "users", "shipping_companies"
end
