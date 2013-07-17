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

ActiveRecord::Schema.define(:version => 20130717162740) do

  create_table "pull_requests", :force => true do |t|
    t.integer  "repo_id"
    t.string   "title"
    t.string   "author"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "status"
    t.integer  "number"
    t.string   "url"
    t.string   "user_login"
    t.string   "user_avatar_url"
    t.string   "head_ref"
    t.string   "head_sha"
    t.string   "clone_url"
  end

  add_index "pull_requests", ["repo_id"], :name => "index_pull_requests_on_repo_id"

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.string   "token"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "github_status"
    t.string   "github_client_id"
    t.string   "github_client_secret"
    t.string   "client_id"
    t.string   "client_secret"
  end

end
