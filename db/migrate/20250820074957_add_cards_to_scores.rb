class AddCardsToScores < ActiveRecord::Migration[8.0]
  def change
    add_column :scores, :cards, :text
  end
end
