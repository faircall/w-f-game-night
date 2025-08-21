class GamesController < ApplicationController
  def index
    @games = Game.all.order(created_at: :desc)
    @players = Player.all.order(career_score: :desc)
  end  

  def new
    @game = Game.new
    @players = Player.all
  end

  def create
    @game = Game.new

    #selected_players = Player.find(params[:game][:player_ids])
    player_ids = game_params[:player_ids].reject(&:blank?)
    @game.players = Player.find(player_ids)

    if @game.save
      @game.create_next_round!
      redirect_to @game, notice: "Game created! Let's play round one!"
    else
      @player = Player.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy

    @game = Game.find(params[:id])
    @game.destroy
    redirect_to root_path, notice: "Game ended"

  end

  def show
    @game = Game.find(params[:id])
    @players = @game.players.order(:name)

    if @game.game_over?
      @completed_rounds = @game.rounds.includes(scores: :player).order(:round_number)
      @current_round = nil
    else 
      @all_rounds = @game.rounds.includes(scores: :player).order(:round_number)
      @current_round = @all_rounds.last
      @completed_rounds = @all_rounds.reject { |r| r == @current_round}
    end

    @running_totals = Hash.new(0)
    (@completed_rounds + [@current_round]).compact.each do |round|    
      round.scores.each do |score|
        @running_totals[score.player] += score.value if score.value.present?
      end
    end    
  end 

  private 
  def game_params
    params.require(:game).permit(player_ids: [])
  end
end
