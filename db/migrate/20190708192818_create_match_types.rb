class CreateMatchTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :match_types do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :match_types, :name
  end
end
