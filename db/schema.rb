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

ActiveRecord::Schema.define(:version => 20130722201909) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "provisioned_mysqls", :force => true do |t|
    t.string   "db"
    t.string   "user"
    t.string   "password"
    t.string   "host"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "provisioned_nginxes", :force => true do |t|
    t.string   "sites_available_file"
    t.string   "sites_enabled_file"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "provisioned_redis", :force => true do |t|
    t.integer  "port"
    t.string   "pidfile"
    t.string   "config_file"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "pull_requests", :force => true do |t|
    t.integer  "repo_id"
    t.string   "title"
    t.string   "author"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "status"
    t.integer  "number"
    t.string   "url"
    t.string   "user_login"
    t.string   "user_avatar_url"
    t.string   "head_ref"
    t.string   "head_sha"
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.integer  "provisioned_mysql_id"
    t.integer  "provisioned_nginx_id"
    t.integer  "provisioned_redis_id"
  end

  add_index "pull_requests", ["repo_id"], :name => "index_pull_requests_on_repo_id"

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.string   "token"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "github_status"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "jira_url"
    t.boolean  "should_provision_mysql"
    t.boolean  "should_provision_nginx"
    t.boolean  "should_provision_redis"
  end

end
