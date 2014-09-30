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

ActiveRecord::Schema.define(version: 20140818042106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "trans_id"
    t.string   "trans_type"
    t.string   "from_customer_id"
    t.string   "to_customer_id"
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.string   "from_name"
    t.string   "to_name"
    t.string   "from_user_role"
    t.string   "to_user_role"
    t.decimal  "amount",            precision: 8, scale: 2
    t.decimal  "from_user_balance", precision: 8, scale: 2
    t.decimal  "to_user_balance",   precision: 8, scale: 2
    t.string   "status"
    t.datetime "cancelled_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["from_user_id"], name: "from_user_id_index", using: :btree
  add_index "transactions", ["to_user_id"], name: "to_user_id_index", using: :btree
  add_index "transactions", ["trans_id"], name: "trans_id_index", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                                 default: "",    null: false
    t.string   "encrypted_password",                                    default: "",    null: false
    t.string   "authentication_token"
    t.string   "company_name"
    t.string   "street_address"
    t.string   "phone"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.text     "summary"
    t.text     "description"
    t.string   "website"
    t.string   "customer_id"
    t.decimal  "balance",                      precision: 15, scale: 2
    t.decimal  "total_funds_raised",           precision: 15, scale: 2
    t.integer  "supporters",                                            default: [],                 array: true
    t.integer  "supported_causes",                                      default: [],                 array: true
    t.boolean  "is_published",                                          default: false
    t.boolean  "is_featured",                                           default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                         default: 0,     null: false
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
    t.datetime "deleted_at"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["company_name"], name: "company_name_index", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["id"], name: "index_users_on_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
