class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.text :words
      t.integer :value
      t.references :round, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
