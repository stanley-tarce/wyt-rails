# frozen_string_literal: true

module Api
  class TradesController < ApplicationController
    prepend_before_action :authenticate_user!
    before_action :check_token # Order
    append_before_action :set_response_header
    # protect_from_forgery with: :null_session
    def index
      if !(trades.zero?)
        trade_container = []
        trades.each do |trade|
          players_array = trade.sent_players.pluck(:player_key).concat(trade.received_players.pluck(:player_key))
          player_stats = Yahoo::Client.player_stats(updated_token, trade.league.league_id, players_array.join(','))
          sent_player_array = []
          received_player_array = []
          trade.sent_players.each do |player|
            sent_player_array << { player_key: player.player_key, player_name: player.player_name, stats: player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player.player_key }[0] }
          end
          trade.received_players.each do |player|
            received_player_array << { player_key: player.player_key, player_name: player.player_name, stats: player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player.player_key}[0]}
          end
          trade_container << { id: trade.id, team_id: trade.team_id, team_name: trade.team_name, sent_players: sent_player_array, received_players: received_player_array }
        end
        render json: trade_container, status: :ok
      else
        render json: trades, status: :ok
      end
    end

    def show
      render json: trade, status: :ok
    end

    def create
      current_user.leagues.find_by_league_id(user_params[:league_key]).trades.create(trade_params)
      trade = Trade.find_by(league_id: user_params[:league_key])
      players_to_send = JSON.parse params[:players_to_send]
      players_to_receive = JSON.parse params[:players_to_receive]

        players_to_send.each do |player|
        trade.sent_players.create(player_key: player[:player_key], player_name: player[:player_name])
      end
      players_to_receive.each do |player|
        trade.received_players.create(player_key: player[:player_key], player_name: player[:player_name])
      end
      render json: {message: "Trade Successful"}, status: :ok
    end

    private
    def trades
      current_user.leagues.find_by_league_id(user_params[:league_key]).trades
    end
    def trade
      current_user.leagues.find_by_league_id(user_params[:league_key]).trades.(params[:id])
    end
    def trade_params
      params.require(:trade).permit(:team_id, :team_name)
    end
  end
end
