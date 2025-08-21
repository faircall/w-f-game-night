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

    if @round.round_number == 8    
      redirect_to @round.game, notice: "Final round scored! Game Over."
    else    
      @round.game.create_next_round!
      redirect_to @round.game, notice: "Round scored! On to the next one."
    end
    
  end

  private 
  
  def apply_round_bonuses round
    scores = round.scores.reload

    max_word_length = scores.map{ |s| s.words.map(&:length).max || 0 }.max
    longest_word_winners = scores.select { |s| (s.words.map(&:length).max || 0) == max_word_length }
    
    if max_word_length > 0 && longest_word_winners.count == 1
      winner = longest_word_winners.first
      new_score = winner.value + 10
      winner.update!(value: new_score, bonus_info: "Longest word! (+10)")
    end 

    max_word_count = scores.map { |s| s.words.length }.max
    most_words_winners = scores.select { |s| s.words.length == max_word_count }

    if max_word_count > 0 && most_words_winners.count == 1
      winner = most_words_winners.first
      new_score = winner.value + 10 # Calculate the new score
      winner.update!(value: new_score, bonus_info: "Most Words! (+10)")
    end
    
  end 

end
