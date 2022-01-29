# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_29_030806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.uuid "trade_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["trade_id"], name: "index_comments_on_trade_id"
  end

  create_table "leagues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "league_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "user_id", null: false
    t.string "team_name"
    t.string "team_key"
    t.string "league_name"
    t.index ["user_id"], name: "index_leagues_on_user_id"
  end

  create_table "received_players", force: :cascade do |t|
    t.string "player_name"
    t.uuid "trade_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "player_key"
    t.index ["trade_id"], name: "index_received_players_on_trade_id"
  end

  create_table "sent_players", force: :cascade do |t|
    t.string "player_name"
    t.uuid "trade_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "player_key"
    t.index ["trade_id"], name: "index_sent_players_on_trade_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "stat_id"
    t.string "stat_name"
    t.string "stat_display_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "token_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "access_token"
    t.string "refresh_token"
    t.string "expiry"
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_token_histories_on_user_id"
  end

  create_table "trades", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "league_id", null: false
    t.string "team_name"
    t.string "team_key"
    t.string "team_logo"
    t.index ["league_id"], name: "index_trades_on_league_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "access_token"
    t.string "refresh_token"
    t.string "expiry"
    t.string "image"
  end

  add_foreign_key "comments", "trades"
  add_foreign_key "leagues", "users"
  add_foreign_key "received_players", "trades"
  add_foreign_key "sent_players", "trades"
  add_foreign_key "sessions", "users"
  add_foreign_key "token_histories", "users"
  add_foreign_key "trades", "leagues"
end
