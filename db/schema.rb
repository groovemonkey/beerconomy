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

ActiveRecord::Schema.define(version: 20141004085044) do

  create_table "beers", force: :cascade do |t|
    t.integer  "sponsor"
    t.string   "recipient"
    t.string   "lat"
    t.string   "lon"
    t.string   "randID"
    t.datetime "receivedAt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
    t.integer  "user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "passhash"
    t.string   "email"
    t.integer  "beersGiven"
    t.integer  "beersReceived"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "beersOffered"
  end

end
