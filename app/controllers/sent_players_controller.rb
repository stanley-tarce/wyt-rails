class SentPlayersController < ApplicationController
  before_action :set_sent_player, only: [:show, :update, :destroy]

  # GET /sent_players
  def index
    @sent_players = SentPlayer.all

    render json: @sent_players
  end

  # GET /sent_players/1
  def show
    render json: @sent_player
  end

  # POST /sent_players
  def create
    @sent_player = SentPlayer.new(sent_player_params)

    if @sent_player.save
      render json: @sent_player, status: :created, location: @sent_player
    else
      render json: @sent_player.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sent_players/1
  def update
    if @sent_player.update(sent_player_params)
      render json: @sent_player
    else
      render json: @sent_player.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sent_players/1
  def destroy
    @sent_player.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_player
      @sent_player = SentPlayer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sent_player_params
      params.fetch(:sent_player, {})
    end
end
