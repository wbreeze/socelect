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

ActiveRecord::Schema.define(:version => 20110221175753) do

  create_table "alternatives", :force => true do |t|
    t.string   "title",       :limit => 256, :null => false
    t.text     "description"
    t.integer  "choice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", :force => true do |t|
    t.string   "title",       :limit => 256, :null => false
    t.text     "description"
    t.datetime "opening"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expressions", :force => true do |t|
    t.integer  "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alternative_id"
    t.integer  "preference_id"
  end

  create_table "preferences", :force => true do |t|
    t.string  "host",      :limit => 256
    t.string  "ip",        :limit => 32
    t.string  "chef",      :limit => 256
    t.integer "choice_id"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

end
