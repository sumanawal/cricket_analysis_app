class CreateGame < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :match_type
      t.date :start_date
      t.date :end_date
      t.integer :number_of_days
      t.string :title
      t.string :season
      t.string :gender
      t.references :home_team
      t.references :away_team
    end
    add_index :games, :title
    add_index :games, :season
  end
end
