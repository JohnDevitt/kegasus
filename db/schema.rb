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

ActiveRecord::Schema.define(version: 20150225115037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "depots", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "volume"
    t.float    "abv"
    t.integer  "category"
  end

  create_table "orders", force: true do |t|
    t.string   "address"
    t.string   "town"
    t.string   "county"
    t.integer  "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "shopping_cart_id"
    t.string   "integer"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "fulfilled"
    t.integer  "route_id"
    t.boolean  "in_transit"
  end

  add_index "orders", ["route_id"], name: "index_route_id", using: :btree

  create_table "pubs", force: true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pubs_routes", id: false, force: true do |t|
    t.integer "pub_id"
    t.integer "route_id"
  end

  add_index "pubs_routes", ["pub_id", "route_id"], name: "index_pubs_routes_on_pub_id_and_route_id", using: :btree
  add_index "pubs_routes", ["route_id"], name: "index_pubs_routes_on_route_id", using: :btree

  create_table "routes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "depot_id"
  end

  add_index "routes", ["depot_id"], name: "index_depot_id", using: :btree

  create_table "rules", force: true do |t|
    t.string   "title"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_cart_items", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "quantity"
    t.integer  "item_id"
    t.string   "item_type"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
