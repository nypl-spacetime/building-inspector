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

ActiveRecord::Schema.define(:version => 20140616164136) do

  create_table "addr", :primary_key => "gid", :force => true do |t|
    t.integer "tlid",      :limit => 8
    t.string  "fromhn",    :limit => 12
    t.string  "tohn",      :limit => 12
    t.string  "side",      :limit => 1
    t.string  "zip",       :limit => 5
    t.string  "plus4",     :limit => 4
    t.string  "fromtyp",   :limit => 1
    t.string  "totyp",     :limit => 1
    t.integer "fromarmid"
    t.integer "toarmid"
    t.string  "arid",      :limit => 22
    t.string  "mtfcc",     :limit => 5
    t.string  "statefp",   :limit => 2
  end

  add_index "addr", ["tlid", "statefp"], :name => "idx_tiger_addr_tlid_statefp"
  add_index "addr", ["zip"], :name => "idx_tiger_addr_zip"

# Could not dump table "addrfeat" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "bg" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "consensuspolygons", :force => true do |t|
    t.string   "task"
    t.integer  "polygon_id"
    t.text     "consensus"
    t.integer  "override_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "consensuspolygons", ["polygon_id", "task"], :name => "index_task_consensus_on_polygon_id", :unique => true
  add_index "consensuspolygons", ["task"], :name => "index_task"

# Could not dump table "county" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "county_lookup", :id => false, :force => true do |t|
    t.integer "st_code",               :null => false
    t.string  "state",   :limit => 2
    t.integer "co_code",               :null => false
    t.string  "name",    :limit => 90
  end

  add_index "county_lookup", ["state"], :name => "county_lookup_state_idx"

  create_table "countysub_lookup", :id => false, :force => true do |t|
    t.integer "st_code",               :null => false
    t.string  "state",   :limit => 2
    t.integer "co_code",               :null => false
    t.string  "county",  :limit => 90
    t.integer "cs_code",               :null => false
    t.string  "name",    :limit => 90
  end

  add_index "countysub_lookup", ["state"], :name => "countysub_lookup_state_idx"

# Could not dump table "cousub" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "direction_lookup", :id => false, :force => true do |t|
    t.string "name",   :limit => 20, :null => false
    t.string "abbrev", :limit => 3
  end

  add_index "direction_lookup", ["abbrev"], :name => "direction_lookup_abbrev_idx"

# Could not dump table "edges" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "faces" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "featnames", :primary_key => "gid", :force => true do |t|
    t.integer "tlid",       :limit => 8
    t.string  "fullname",   :limit => 100
    t.string  "name",       :limit => 100
    t.string  "predirabrv", :limit => 15
    t.string  "pretypabrv", :limit => 50
    t.string  "prequalabr", :limit => 15
    t.string  "sufdirabrv", :limit => 15
    t.string  "suftypabrv", :limit => 50
    t.string  "sufqualabr", :limit => 15
    t.string  "predir",     :limit => 2
    t.string  "pretyp",     :limit => 3
    t.string  "prequal",    :limit => 2
    t.string  "sufdir",     :limit => 2
    t.string  "suftyp",     :limit => 3
    t.string  "sufqual",    :limit => 2
    t.string  "linearid",   :limit => 22
    t.string  "mtfcc",      :limit => 5
    t.string  "paflag",     :limit => 1
    t.string  "statefp",    :limit => 2
  end

  add_index "featnames", ["tlid", "statefp"], :name => "idx_tiger_featnames_tlid_statefp"

  create_table "flags", :force => true do |t|
    t.string   "flag_type"
    t.integer  "polygon_id"
    t.string   "session_id"
    t.text     "flag_value"
    t.boolean  "is_primary"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.decimal  "latitude",   :precision => 15, :scale => 12
    t.decimal  "longitude",  :precision => 15, :scale => 12
  end

  add_index "flags", ["polygon_id"], :name => "polygon_index"
  add_index "flags", ["session_id", "flag_type", "polygon_id", "flag_value", "latitude", "longitude"], :name => "index_flags_on_session_id", :unique => true

  create_table "geocode_settings", :id => false, :force => true do |t|
    t.text "name",       :null => false
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "loader_lookuptables", :id => false, :force => true do |t|
    t.integer "process_order",                        :default => 1000,  :null => false
    t.text    "lookup_name",                                             :null => false
    t.text    "table_name"
    t.boolean "single_mode",                          :default => true,  :null => false
    t.boolean "load",                                 :default => true,  :null => false
    t.boolean "level_county",                         :default => false, :null => false
    t.boolean "level_state",                          :default => false, :null => false
    t.boolean "level_nation",                         :default => false, :null => false
    t.text    "post_load_process"
    t.boolean "single_geom_mode",                     :default => false
    t.string  "insert_mode",           :limit => 1,   :default => "c",   :null => false
    t.text    "pre_load_process"
    t.string  "columns_exclude",       :limit => nil
    t.text    "website_root_override"
  end

  create_table "loader_platform", :id => false, :force => true do |t|
    t.string "os",                     :limit => 50, :null => false
    t.text   "declare_sect"
    t.text   "pgbin"
    t.text   "wget"
    t.text   "unzip_command"
    t.text   "psql"
    t.text   "path_sep"
    t.text   "loader"
    t.text   "environ_set_command"
    t.text   "county_process_command"
  end

  create_table "loader_variables", :id => false, :force => true do |t|
    t.string "tiger_year",     :limit => 4, :null => false
    t.text   "website_root"
    t.text   "staging_fold"
    t.text   "data_schema"
    t.text   "staging_schema"
  end

  create_table "pagc_gaz", :force => true do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", :default => true, :null => false
  end

  create_table "pagc_lex", :force => true do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", :default => true, :null => false
  end

  create_table "pagc_rules", :force => true do |t|
    t.text    "rule"
    t.boolean "is_custom", :default => true
  end

# Could not dump table "place" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "place_lookup", :id => false, :force => true do |t|
    t.integer "st_code",               :null => false
    t.string  "state",   :limit => 2
    t.integer "pl_code",               :null => false
    t.string  "name",    :limit => 90
  end

  add_index "place_lookup", ["state"], :name => "place_lookup_state_idx"

  create_table "polygons", :force => true do |t|
    t.text     "geometry"
    t.string   "status"
    t.text     "vectorizer_json"
    t.integer  "sheet_id"
    t.string   "color"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.integer  "dn"
    t.integer  "flag_count",                                                 :default => 0
    t.string   "consensus"
    t.decimal  "centroid_lat",               :precision => 15, :scale => 12
    t.decimal  "centroid_lon",               :precision => 15, :scale => 12
    t.string   "consensus_address"
    t.text     "consensus_polygonfix_value"
    t.boolean  "consensus_polygonfix"
  end

  add_index "polygons", ["consensus"], :name => "consensus_index2"
  add_index "polygons", ["sheet_id", "consensus"], :name => "consensus_index"
  add_index "polygons", ["sheet_id", "consensus_address"], :name => "consensus_address_index"
  add_index "polygons", ["sheet_id", "consensus_polygonfix"], :name => "consensus_polygonfix_index"

  create_table "secondary_unit_lookup", :id => false, :force => true do |t|
    t.string "name",   :limit => 20, :null => false
    t.string "abbrev", :limit => 5
  end

  add_index "secondary_unit_lookup", ["abbrev"], :name => "secondary_unit_lookup_abbrev_idx"

  create_table "sheets", :force => true do |t|
    t.string   "status"
    t.string   "bbox"
    t.integer  "map_id"
    t.string   "map_url"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "layer_id"
    t.string   "consensus"
    t.string   "consensus_address"
    t.boolean  "consensus_polygonfix"
  end

  add_index "sheets", ["consensus"], :name => "sheet_consensus_index"
  add_index "sheets", ["consensus_address"], :name => "sheet_consensus_address_index"
  add_index "sheets", ["consensus_polygonfix"], :name => "sheet_consensus_polygonfix_index"
  add_index "sheets", ["layer_id"], :name => "index_sheets_on_layer_id"

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

# Could not dump table "state" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "state_lookup", :id => false, :force => true do |t|
    t.integer "st_code",               :null => false
    t.string  "name",    :limit => 40
    t.string  "abbrev",  :limit => 3
    t.string  "statefp", :limit => 2
  end

  add_index "state_lookup", ["abbrev"], :name => "state_lookup_abbrev_key", :unique => true
  add_index "state_lookup", ["name"], :name => "state_lookup_name_key", :unique => true
  add_index "state_lookup", ["statefp"], :name => "state_lookup_statefp_key", :unique => true

  create_table "street_type_lookup", :id => false, :force => true do |t|
    t.string  "name",   :limit => 50,                    :null => false
    t.string  "abbrev", :limit => 50
    t.boolean "is_hw",                :default => false, :null => false
  end

  add_index "street_type_lookup", ["abbrev"], :name => "street_type_lookup_abbrev_idx"

# Could not dump table "tabblock" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "tract" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",          :null => false
    t.string   "encrypted_password",     :default => "",          :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "provider",               :default => "google"
    t.string   "uid"
    t.string   "name"
    t.string   "role",                   :default => "inspector"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "usersessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

# Could not dump table "zcta5" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "zip_lookup", :id => false, :force => true do |t|
    t.integer "zip",                   :null => false
    t.integer "st_code"
    t.string  "state",   :limit => 2
    t.integer "co_code"
    t.string  "county",  :limit => 90
    t.integer "cs_code"
    t.string  "cousub",  :limit => 90
    t.integer "pl_code"
    t.string  "place",   :limit => 90
    t.integer "cnt"
  end

  create_table "zip_lookup_all", :id => false, :force => true do |t|
    t.integer "zip"
    t.integer "st_code"
    t.string  "state",   :limit => 2
    t.integer "co_code"
    t.string  "county",  :limit => 90
    t.integer "cs_code"
    t.string  "cousub",  :limit => 90
    t.integer "pl_code"
    t.string  "place",   :limit => 90
    t.integer "cnt"
  end

  create_table "zip_lookup_base", :id => false, :force => true do |t|
    t.string "zip",     :limit => 5,  :null => false
    t.string "state",   :limit => 40
    t.string "county",  :limit => 90
    t.string "city",    :limit => 90
    t.string "statefp", :limit => 2
  end

  create_table "zip_state", :id => false, :force => true do |t|
    t.string "zip",     :limit => 5, :null => false
    t.string "stusps",  :limit => 2, :null => false
    t.string "statefp", :limit => 2
  end

  create_table "zip_state_loc", :id => false, :force => true do |t|
    t.string "zip",     :limit => 5,   :null => false
    t.string "stusps",  :limit => 2,   :null => false
    t.string "statefp", :limit => 2
    t.string "place",   :limit => 100, :null => false
  end

end
