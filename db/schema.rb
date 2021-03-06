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

ActiveRecord::Schema.define(version: 20150528044158) do

  create_table "songs", force: :cascade do |t|
    t.string   "name"
    t.string   "basename"
    t.string   "dir"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "score",      default: 0, null: false
  end

  add_index "songs", ["basename"], name: "index_songs_on_basename"
  add_index "songs", ["dir"], name: "index_songs_on_dir"
  add_index "songs", ["name"], name: "index_songs_on_name"
  add_index "songs", ["score"], name: "index_songs_on_score"

  create_table "thumbs", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "session_id"
    t.boolean  "up"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "thumbs", ["session_id"], name: "index_thumbs_on_session_id"
  add_index "thumbs", ["song_id"], name: "index_thumbs_on_song_id"

end
