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

ActiveRecord::Schema.define(version: 20160222115948) do

  create_table "project_progresses", force: :cascade do |t|
    t.string   "project_id",    limit: 255
    t.integer  "money",         limit: 4
    t.integer  "supporter_num", limit: 4
    t.date     "datetime"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "projects", id: false, force: :cascade do |t|
    t.string   "id",            limit: 255,   null: false
    t.string   "title",         limit: 255
    t.string   "genre",         limit: 255
    t.string   "owner_id",      limit: 255
    t.text     "content",       limit: 65535
    t.integer  "goal_money",    limit: 4
    t.integer  "money",         limit: 4
    t.date     "deadline"
    t.integer  "supporter_num", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "platform",      limit: 255
    t.integer  "flag",          limit: 4
  end

  add_index "projects", ["id"], name: "index_projects_on_id", unique: true, using: :btree

end
