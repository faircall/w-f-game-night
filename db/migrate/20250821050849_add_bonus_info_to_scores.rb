class AddBonusInfoToScores < ActiveRecord::Migration[8.0]
  def change
    add_column :scores, :bonus_info, :string
  end
end
