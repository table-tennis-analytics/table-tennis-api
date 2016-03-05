class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :challenger, index: true
      t.references :challenged, index: true
      t.references :winner, index: true
      t.integer :challenger_score
      t.integer :challenged_score

      t.timestamps null: false
    end
  end
end
