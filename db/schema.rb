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

ActiveRecord::Schema.define(version: 2019_12_10_220855) do

  create_table "alternatives", force: :cascade do |t|
    t.string "title", limit: 256, null: false
    t.text "description"
    t.integer "choice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", force: :cascade do |t|
    t.string "title", limit: 256, null: false
    t.text "description"
    t.datetime "opening"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "read_token", limit: 32
    t.string "edit_token", limit: 32
    t.boolean "intermediate", default: false, null: false
    t.boolean "public", default: false, null: false
    t.integer "result_state"
    t.text "result_parto"
    t.index ["deadline"], name: "index_choices_on_deadline"
    t.index ["edit_token"], name: "index_choices_on_edit_token", unique: true
    t.index ["public"], name: "index_choices_on_public"
    t.index ["read_token"], name: "index_choices_on_read_token", unique: true
    t.index ["result_state"], name: "index_choices_on_result_state"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "expressions", force: :cascade do |t|
    t.integer "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "alternative_id"
    t.integer "preference_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "host", limit: 256
    t.string "ip", limit: 32
    t.string "chef", limit: 256
    t.integer "choice_id"
    t.string "token", limit: 32
    t.index ["token"], name: "index_preferences_on_token", unique: true
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string "key", limit: 40
    t.string "value", limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "idx_key"
  end

end
