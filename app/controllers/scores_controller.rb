class ScoresController < ApplicationController
  def create
    @round = Round.find(params[:round_id])

    params[:scores].each do |player_id, player_params|
      player = Player.find(player_id)

      clean_words = player_params[:words].tr(',', ' ').squish
      clean_cards = player_params[:cards].tr(',', ' ').squish

      words_array = clean_words.split(' ')
      cards_array = clean_cards.split(' ')

      @round.scores.create!(
        player: player,
        words: words_array,
        cards: cards_array,
      )
    end

    apply_round_bonuses(@round)

    @round.game.create_next_round!

    redirect_to @round.game, notice: "Round complete! Onto the next one"      
  end

  private 
  
  def apply_round_bonuses round

    

  end 

end
