class CreateMatchDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :match_details do |t|
      t.references :game
      t.references :match_information
      t.integer :over_number
      t.integer :ball_number
      t.integer :inning_number
      t.references :batting_team
      t.references :balling_team
      t.string :striker_batsman
      t.string :non_striker_batsman
      t.string :baller
      t.integer :run_count
      t.integer :extra_run
      t.string :wkt_type
      t.string :wkt_taker
    end
    add_index :match_details, :striker_batsman
    add_index :match_details, :non_striker_batsman
    add_index :match_details, :baller
  end
end
