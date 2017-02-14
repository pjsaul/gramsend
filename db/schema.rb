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

ActiveRecord::Schema.define(version: 20160123182603) do

  create_table "postcards", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "lob_id"
    t.string   "to_name"
    t.string   "to_address_one"
    t.string   "to_address_two"
    t.string   "to_city"
    t.string   "to_state"
    t.string   "to_zip"
    t.string   "to_country"
    t.string   "from_name"
    t.string   "from_address_one"
    t.string   "from_address_two"
    t.string   "from_city"
    t.string   "from_state"
    t.string   "from_zip"
    t.string   "from_country"
    t.string   "thumbnail_front_url"
    t.string   "thumbnail_back_url"
    t.datetime "sent_date"
    t.datetime "expected_delivery_date"
    t.string   "insta_postusername"
    t.text     "insta_caption"
    t.string   "insta_location"
    t.datetime "insta_date"
    t.integer  "insta_likes_count"
    t.integer  "insta_comments_count"
    t.text     "insta_comments"
    t.string   "insta_fromusername"
    t.text     "postcard_message"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "insta_id"
    t.integer  "error"
    t.string   "insta_url"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "insta_id"
    t.string   "insta_name"
    t.datetime "last_activity"
    t.integer  "admin"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "addr_name"
    t.string   "addr_address_one"
    t.string   "addr_address_two"
    t.string   "addr_city"
    t.string   "addr_state"
    t.string   "addr_country"
    t.string   "addr_zip"
    t.integer  "followers_count"
    t.integer  "following_count"
    t.integer  "pageviews"
    t.integer  "formviews"
  end

end
