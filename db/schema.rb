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

ActiveRecord::Schema.define(:version => 20130518090458) do

  create_table "albums", :force => true do |t|
    t.integer  "owner_id",                        :null => false
    t.integer  "privacy_level_id",                :null => false
    t.string   "title",            :limit => 64
    t.string   "description",      :limit => 512
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "friends", :force => true do |t|
    t.integer  "initiator_id"
    t.integer  "recipient_id"
    t.string   "confirmation", :limit => 32
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "geotag_infos", :force => true do |t|
    t.integer  "image_id",                                 :null => false
    t.decimal  "longitude",  :precision => 9, :scale => 6
    t.decimal  "latitude",   :precision => 9, :scale => 6
    t.decimal  "accuracy",   :precision => 9, :scale => 6
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "album_id",                  :null => false
    t.string   "uniqid",     :limit => 16,  :null => false
    t.string   "caption",    :limit => 256
    t.integer  "width"
    t.integer  "height"
    t.string   "mime",       :limit => 32
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "images", ["uniqid"], :name => "index_images_on_uniqid", :unique => true

  create_table "privacy_levels", :force => true do |t|
    t.string   "hint",       :limit => 16
    t.string   "display",    :limit => 32
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "user_roles", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "users", :force => true do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
