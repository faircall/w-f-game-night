class Game < ApplicationRecord
    has_many :rounds, dependent: :destroy
    has_many :game_players, dependent: :destroy
    has_many :players, through: :game_players

    validates :players, presence: true

    def create_next_round!
        latest_round = rounds.order(round_number: :desc).first

        next_number = latest_round ? latest_round.round_number + 1 : 1

        return if next_number > 8

        rounds.create!(round_number: next_number)
    end

    def game_over?    
        rounds.count == 8 && rounds.last.scores.any?
    end
end
