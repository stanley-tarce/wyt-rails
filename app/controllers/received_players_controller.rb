class ReceivedPlayersController < ApplicationController
  before_action :set_received_player, only: [:show, :update, :destroy]

  # GET /received_players
  def index
    @received_players = ReceivedPlayer.all

    render json: @received_players
  end

  # GET /received_players/1
  def show
    render json: @received_player
  end

  # POST /received_players
  def create
    @received_player = ReceivedPlayer.new(received_player_params)

    if @received_player.save
      render json: @received_player, status: :created, location: @received_player
    else
      render json: @received_player.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /received_players/1
  def update
    if @received_player.update(received_player_params)
      render json: @received_player
    else
      render json: @received_player.errors, status: :unprocessable_entity
    end
  end

  # DELETE /received_players/1
  def destroy
    @received_player.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_received_player
      @received_player = ReceivedPlayer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def received_player_params
      params.fetch(:received_player, {})
    end
end
