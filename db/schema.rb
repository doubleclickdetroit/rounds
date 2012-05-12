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

ActiveRecord::Schema.define(:version => 20120512073440) do

  create_table "ballots", :force => true do |t|
    t.integer  "slide_id"
    t.integer  "fid"
    t.integer  "vote"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ballots", ["fid"], :name => "index_ballots_on_fid"
  add_index "ballots", ["slide_id"], :name => "index_ballots_on_slide_id"

  create_table "blacklist_entries", :id => false, :force => true do |t|
    t.integer  "user_fid"
    t.integer  "blocked_fid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "blacklist_entries", ["user_fid"], :name => "index_blacklist_entries_on_user_fid"

  create_table "comments", :force => true do |t|
    t.integer  "slide_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "text"
    t.integer  "fid"
    t.boolean  "inappropriate"
  end

  add_index "comments", ["fid"], :name => "index_comments_on_fid"
  add_index "comments", ["slide_id"], :name => "index_comments_on_slide_id"

  create_table "invitations", :force => true do |t|
    t.integer  "fid"
    t.integer  "invited_fid"
    t.integer  "round_id"
    t.boolean  "accepted",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "invitations", ["fid"], :name => "index_invitations_on_fid"
  add_index "invitations", ["invited_fid"], :name => "index_invitations_on_invited_fid"
  add_index "invitations", ["round_id"], :name => "index_invitations_on_round_id"

  create_table "round_locks", :force => true do |t|
    t.integer  "round_id"
    t.integer  "fid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "round_locks", ["round_id"], :name => "index_round_locks_on_round_id"

  create_table "rounds", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "fid"
  end

  add_index "rounds", ["fid"], :name => "index_rounds_on_fid"

  create_table "slides", :force => true do |t|
    t.integer  "round_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "text"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "type"
    t.integer  "position"
    t.integer  "fid"
    t.integer  "votes",             :default => 0
  end

  add_index "slides", ["fid"], :name => "index_slides_on_fid"
  add_index "slides", ["round_id"], :name => "index_slides_on_round_id"

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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "fid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "watchings", :force => true do |t|
    t.integer  "round_id"
    t.integer  "fid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "watchings", ["fid"], :name => "index_watchings_on_fid"
  add_index "watchings", ["round_id"], :name => "index_watchings_on_round_id"

end
