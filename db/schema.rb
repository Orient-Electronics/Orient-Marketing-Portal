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

ActiveRecord::Schema.define(:version => 20140423064553) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "status",         :default => "unread"
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "activity_settings", :force => true do |t|
    t.integer  "subscriber_id"
    t.string   "activity_name"
    t.string   "activity_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "announcements", :force => true do |t|
    t.string   "announcement"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "avatars", :force => true do |t|
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.integer  "avatarable_id"
    t.string   "avatarable_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "brands_product_categories", :id => false, :force => true do |t|
    t.integer "product_category_id"
    t.integer "brand_id"
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

  create_table "dealers", :force => true do |t|
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

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shop_id"
    t.integer  "dealer_id"
    t.integer  "product_category_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "published",           :default => false
    t.integer  "task_id"
    t.integer  "approved_id"
  end

  create_table "product_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "info"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "product_category_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "report_lines", :force => true do |t|
    t.integer  "report_id"
    t.integer  "product_id"
    t.integer  "brand_id"
    t.integer  "data"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "product_category_id"
  end

  create_table "reports", :force => true do |t|
    t.integer  "shop_id"
    t.integer  "user_id"
    t.string   "report_type"
    t.text     "data"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "week"
    t.integer  "year"
    t.integer  "post_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "symbol"
    t.text     "notes"
    t.string   "action"
    t.string   "entity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_user_types", :force => true do |t|
    t.integer  "user_type_id"
    t.integer  "role_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "roles_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.integer  "shop_category_id"
    t.integer  "location_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "dealer_id"
    t.boolean  "orient_dealer",    :default => false
  end

  create_table "subscribers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscribe_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tasks", :force => true do |t|
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "assigned_by"
    t.integer  "assigned_to"
    t.text     "comment"
    t.integer  "shop_id"
    t.string   "status",      :default => "pending"
    t.string   "task_type",   :default => "report"
    t.datetime "deadline"
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

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "phone_number"
    t.integer  "user_type_id"
    t.boolean  "view_announcement",      :default => true
  end

  add_index "users", ["email"], :name => "index_representatives_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_representatives_on_reset_password_token", :unique => true

end
