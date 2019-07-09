class CreateMatchInformation < ActiveRecord::Migration[5.2]
  def change
    create_table :match_informations do |t|
      t.references :game
      t.integer :match_number
      t.string :venue
      t.string :city
      t.references :toss_winner
      t.string :toss_decision
      t.string :player_of_match
      t.string :principal_umpire
      t.string :cheif_umpire
      t.string :tv_umpire
      t.string :match_refree
      t.string :reserve_umpire
      t.references :winner
      t.integer :winner_inning
      t.string :win_type
      t.integer :win_by
    end
    add_index :match_informations, :player_of_match
    add_index :match_informations, :win_type
    add_index :match_informations, :winner_inning
  end
end
