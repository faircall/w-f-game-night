class Round < ApplicationRecord
  belongs_to :game
  has_many :scores

  def complete?
    scores.count == game.players.count
  end

  def score_round!
    return false unless complete?

    #TODO (Cooper) : find and apply bonuses

    game.create_next_round!
    
    true
  end
end
