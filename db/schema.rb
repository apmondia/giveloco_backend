# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140811171819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "redemptions", force: true do |t|
    t.integer  "voucher_id"
    t.integer  "vendor_id"
    t.integer  "redeemed_by_id"
    t.string   "redeemer_name"
    t.string   "vendor_name"
    t.decimal  "value",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "trans_id"
    t.integer  "created_by_id"
    t.integer  "accepted_by_id"
    t.string   "trans_type"
    t.string   "from_name"
    t.string   "to_name"
    t.decimal  "total_debt",     precision: 8, scale: 2
    t.decimal  "total_credit",   precision: 8, scale: 2
    t.decimal  "remaining_debt", precision: 8, scale: 2
    t.string   "status"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                           default: "", null: false
    t.string   "encrypted_password",                              default: "", null: false
    t.string   "authentication_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.text     "tags",                                            default: [],              array: true
    t.text     "summary"
    t.text     "description"
    t.string   "website"
    t.decimal  "balance",                precision: 15, scale: 2
    t.integer  "total_debits"
    t.decimal  "total_debits_value",     precision: 15, scale: 2
    t.integer  "total_credits"
    t.decimal  "total_credits_value",    precision: 15, scale: 2
    t.boolean  "is_featured"
    t.integer  "supporters",                                      default: [],              array: true
    t.integer  "supported_causes",                                default: [],              array: true
    t.datetime "deleted_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vouchers", force: true do |t|
    t.integer  "issued_by_id"
    t.integer  "claimed_by_id"
    t.string   "issued_by_name"
    t.string   "claimed_by_name"
    t.decimal  "max_value",       precision: 8, scale: 2
    t.boolean  "redeemed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
