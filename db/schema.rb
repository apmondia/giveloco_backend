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

ActiveRecord::Schema.define(version: 20140722231406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: true do |t|
    t.text     "type"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "company_name"
    t.text     "email"
    t.text     "password"
    t.text     "password_salt"
    t.text     "street_address"
    t.text     "city"
    t.text     "state"
    t.text     "country"
    t.text     "zip"
    t.text     "tags"
    t.text     "summary"
    t.text     "description"
    t.text     "website"
    t.decimal  "balance",                      precision: 15, scale: 2
    t.integer  "total_debits"
    t.decimal  "total_debits_value",           precision: 15, scale: 2
    t.integer  "total_credits"
    t.decimal  "total_credits_value",          precision: 15, scale: 2
    t.boolean  "is_featured"
    t.integer  "supporters"
    t.integer  "supported_causes"
    t.integer  "vouchers"
    t.integer  "transactions"
    t.integer  "redemptions"
    t.boolean  "is_authenticated"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
