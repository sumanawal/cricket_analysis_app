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

ActiveRecord::Schema.define(version: 2019_07_08_200552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "match_type_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "number_of_days"
    t.string "title"
    t.string "season"
    t.string "gender"
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["match_type_id"], name: "index_games_on_match_type_id"
    t.index ["season"], name: "index_games_on_season"
    t.index ["title"], name: "index_games_on_title"
  end

  create_table "match_details", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "match_information_id"
    t.integer "over_number"
    t.integer "ball_number"
    t.integer "inning_number"
    t.bigint "batting_team_id"
    t.bigint "balling_team_id"
    t.string "striker_batsman"
    t.string "non_striker_batsman"
    t.string "baller"
    t.integer "run_count"
    t.integer "extra_run"
    t.string "wkt_type"
    t.string "wkt_taker"
    t.index ["baller"], name: "index_match_details_on_baller"
    t.index ["balling_team_id"], name: "index_match_details_on_balling_team_id"
    t.index ["batting_team_id"], name: "index_match_details_on_batting_team_id"
    t.index ["game_id"], name: "index_match_details_on_game_id"
    t.index ["match_information_id"], name: "index_match_details_on_match_information_id"
    t.index ["non_striker_batsman"], name: "index_match_details_on_non_striker_batsman"
    t.index ["striker_batsman"], name: "index_match_details_on_striker_batsman"
  end

  create_table "match_informations", force: :cascade do |t|
    t.bigint "game_id"
    t.integer "match_number"
    t.string "venue"
    t.string "city"
    t.bigint "toss_winner_id"
    t.string "toss_decision"
    t.string "player_of_match"
    t.string "principal_umpire"
    t.string "cheif_umpire"
    t.string "tv_umpire"
    t.string "match_refree"
    t.string "reserve_umpire"
    t.bigint "winner_id"
    t.integer "winner_inning"
    t.string "win_type"
    t.integer "win_by"
    t.index ["game_id"], name: "index_match_informations_on_game_id"
    t.index ["player_of_match"], name: "index_match_informations_on_player_of_match"
    t.index ["toss_winner_id"], name: "index_match_informations_on_toss_winner_id"
    t.index ["win_type"], name: "index_match_informations_on_win_type"
    t.index ["winner_id"], name: "index_match_informations_on_winner_id"
    t.index ["winner_inning"], name: "index_match_informations_on_winner_inning"
  end

  create_table "match_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_match_types_on_name"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name"
  end

end
