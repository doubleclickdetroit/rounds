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

ActiveRecord::Schema.define(:version => 20120621103542) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ballots", :force => true do |t|
    t.integer  "slide_id"
    t.integer  "user_id"
    t.integer  "vote"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ballots", ["slide_id"], :name => "index_ballots_on_slide_id"
  add_index "ballots", ["user_id"], :name => "index_ballots_on_user_id"

  create_table "blacklist_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "blocked_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "blacklist_entries", ["user_id"], :name => "index_blacklist_entries_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "slide_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "text"
    t.boolean  "inappropriate"
  end

  add_index "comments", ["slide_id"], :name => "index_comments_on_slide_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invited_user_id"
    t.integer  "round_id"
    t.boolean  "read",             :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "private"
    t.string   "invited_provider"
    t.string   "invited_uid"
  end

  add_index "invitations", ["invited_user_id"], :name => "index_invitations_on_invited_user_id"
  add_index "invitations", ["round_id"], :name => "index_invitations_on_round_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "round_locks", :force => true do |t|
    t.integer  "round_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "round_locks", ["round_id"], :name => "index_round_locks_on_round_id"

  create_table "rounds", :force => true do |t|
    t.integer  "user_id"
    t.integer  "slide_limit"
    t.boolean  "complete",    :default => false
    t.boolean  "private",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "rounds", ["user_id"], :name => "index_rounds_on_user_id"

  create_table "slides", :force => true do |t|
    t.integer  "user_id"
    t.integer  "round_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "text"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "type"
    t.integer  "votes",             :default => 0
  end

  add_index "slides", ["round_id"], :name => "index_slides_on_round_id"
  add_index "slides", ["type"], :name => "index_slides_on_type"
  add_index "slides", ["user_id"], :name => "index_slides_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "friend_ids_csv"
    t.string   "image_path"
  end

  create_table "watchings", :force => true do |t|
    t.integer  "round_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  add_index "watchings", ["round_id"], :name => "index_watchings_on_round_id"
  add_index "watchings", ["type"], :name => "index_watchings_on_type"
  add_index "watchings", ["user_id"], :name => "index_watchings_on_user_id"

end
