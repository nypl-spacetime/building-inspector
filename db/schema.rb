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

ActiveRecord::Schema.define(:version => 20130823193914) do

  create_table "flags", :force => true do |t|
    t.string   "type"
    t.integer  "polygon_id"
    t.string   "session_id"
    t.string   "flag_value"
    t.boolean  "is_primary"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "polygons", :force => true do |t|
    t.text     "geometry"
    t.string   "status"
    t.text     "vectorizer_json"
    t.integer  "sheet_id"
    t.string   "color"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "dn"
  end

  create_table "sheets", :force => true do |t|
    t.string   "status"
    t.string   "bbox"
    t.integer  "map_id"
    t.string   "map_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
