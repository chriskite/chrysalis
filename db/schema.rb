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

ActiveRecord::Schema.define(:version => 20130715185518) do

  create_table "builds", :force => true do |t|
    t.integer  "pull_request_id"
    t.integer  "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "builds", ["pull_request_id"], :name => "index_builds_on_pull_request_id"

  create_table "pull_requests", :force => true do |t|
    t.integer  "repo_id"
    t.string   "branch"
    t.string   "author"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pull_requests", ["repo_id"], :name => "index_pull_requests_on_repo_id"

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
