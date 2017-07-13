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

ActiveRecord::Schema.define(version: 20170713103940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: :cascade do |t|
    t.string "meeting"
    t.string "race"
    t.string "selection"
    t.string "odds"
    t.string "points"
    t.integer "stake"
    t.string "betId"
    t.string "meetingId"
    t.string "marketId"
    t.string "selectionId"
    t.string "result"
    t.string "profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "suggested"
    t.integer "portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.integer "initial_bankroll"
    t.integer "current_bankroll"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.date "date"
    t.integer "previous"
    t.integer "after"
    t.integer "profit"
    t.integer "total_staked"
    t.integer "running_profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "portfolio_id"
  end

end
