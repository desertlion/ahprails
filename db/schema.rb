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

ActiveRecord::Schema.define(version: 20150723114904) do

  create_table "area_details", force: :cascade do |t|
    t.integer "area_id"
    t.string  "name"
    t.string  "detail"
    t.string  "detail_type"
    t.integer "detail_id"
  end

  add_index "area_details", ["area_id"], name: "index_area_detail_on_area_id"

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "ahp"
  end

  create_table "plant_details", force: :cascade do |t|
    t.integer  "plant_id"
    t.string   "name"
    t.string   "detail"
    t.string   "detail_type"
    t.integer  "detail_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "plants", force: :cascade do |t|
    t.string   "name"
    t.decimal  "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcriteria", force: :cascade do |t|
    t.string   "name"
    t.integer  "criteria_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "ahp"
    t.boolean  "tipe",        default: true
  end

  add_index "subcriteria", ["criteria_id"], name: "index_subcriteria_on_criteria_id"

  create_table "unstructured_data", force: :cascade do |t|
    t.string   "name"
    t.integer  "subcriterium_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "ahp"
  end

  add_index "unstructured_data", ["subcriterium_id"], name: "index_unstructured_data_on_subcriterium_id"

end
