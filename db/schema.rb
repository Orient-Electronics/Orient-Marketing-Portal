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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130726040419) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "brands_products", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "brand_id"
  end

  add_index "brands_products", ["product_id", "brand_id"], :name => "index_brands_products_on_product_id_and_brand_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.integer  "city_id"
    t.string   "area"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "managers", :force => true do |t|
    t.string   "name"
    t.integer  "cell_number"
    t.date     "dob"
    t.integer  "shop_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.integer  "cell_number"
    t.date     "dob"
    t.integer  "shop_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "info"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "report_lines", :force => true do |t|
    t.integer  "report_id"
    t.integer  "product_id"
    t.integer  "brand_id"
    t.integer  "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "shop_id"
    t.integer  "representative_id"
    t.string   "report_type"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "data"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "representatives", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "phone_number"
  end

  add_index "representatives", ["email"], :name => "index_representatives_on_email", :unique => true
  add_index "representatives", ["reset_password_token"], :name => "index_representatives_on_reset_password_token", :unique => true

  create_table "shop_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shops", :force => true do |t|
    t.string   "dealer_name"
    t.integer  "phone"
    t.string   "website"
    t.string   "email"
    t.string   "address"
    t.boolean  "dealer"
    t.integer  "shop_category_id"
    t.integer  "location_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "uploads", :force => true do |t|
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
  end

end
