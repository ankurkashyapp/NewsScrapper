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

ActiveRecord::Schema.define(version: 20170810150528) do

  create_table "app_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "app_name"
    t.string   "latest_version"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "news_articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "title",        limit: 65535
    t.string   "image"
    t.string   "date"
    t.text     "summary",      limit: 65535
    t.integer  "news_feed_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "city",                       default: "Saharanpur"
    t.index ["news_feed_id"], name: "index_news_articles_on_news_feed_id", using: :btree
    t.index ["news_feed_id"], name: "news_feed_id", unique: true, using: :btree
  end

  create_table "news_feeds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "title",      limit: 65535
    t.text     "summary",    limit: 65535
    t.string   "image"
    t.string   "link"
    t.string   "date"
    t.string   "city"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "address",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_foreign_key "news_articles", "news_feeds"
end
