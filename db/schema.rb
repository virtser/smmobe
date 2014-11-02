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

ActiveRecord::Schema.define(version: 20141210151100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaign_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_type_id",   default: 1, null: false
    t.integer  "campaign_status_id", default: 1, null: false
    t.integer  "user_id",                        null: false
  end

  create_table "customers", force: true do |t|
    t.string   "phone"
    t.integer  "campaign_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "custom1"
    t.string   "custom2"
    t.string   "custom3"
  end

  create_table "message_receives", force: true do |t|
    t.string   "sid"
    t.datetime "date"
    t.text     "from_phone"
    t.text     "to_phone"
    t.text     "body"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id"
    t.integer  "user_id"
  end

  create_table "message_sends", force: true do |t|
    t.string   "sid"
    t.datetime "date"
    t.text     "from_phone"
    t.text     "to_phone"
    t.text     "body"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id"
  end

  create_table "messages", force: true do |t|
    t.string   "text"
    t.integer  "campaign_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "campaign_phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
