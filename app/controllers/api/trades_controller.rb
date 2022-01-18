# frozen_string_literal: true

module Api
  class TradesController < ApplicationController
    prepend_before_action :authenticate_user!
    before_action :check_token # Order
    append_before_action :set_response_header
    # protect_from_forgery with: :null_session
    def index
      render json: trades, status: :ok
    end

    def show
      user_roster = Yahoo::Client.players(updated_token,  trade.league.team_key)
      totrade_roster = Yahoo::Client.players(updated_token, trade.team_key)
      players_array = trade.sent_players.pluck(:player_key).concat(trade.received_players.pluck(:player_key))
      player_stats = Yahoo::Client.player_stats(updated_token, trade.league.league_key, players_array.join(","))
      players_to_send = []
      players_to_receive = []
      trade.sent_players.each do |player|
        roster = user_roster[:data][:players].select {|roster| roster[:player_key] == player.player_key }[0] 
        players_to_send << { player_name: player.player_name, player_key: player.player_key, player_team_full: roster[:player_team_full], player_team_abbr: roster[:player_team_abbr], player_number: roster[:player_number], player_positions: roster[:player_positions], player_image: roster[:player_image], stats: player_stats[:data][:player_stats].select{ |stat| stat['player_key'] == player.player_key }[0] }
      end
      trade.received_players.each do |player|
        roster = totrade_roster[:data][:players].select {|roster| roster[:player_key] == player.player_key }[0]
        players_to_receive << { player_name: player.player_name, player_key: player.player_key, player_team_full: roster[:player_team_full], player_team_abbr: roster[:player_team_abbr], player_number: roster[:player_number], player_positions: roster[:player_positions], player_image: roster[:player_image], stats: player_stats[:data][:player_stats].select{ |stat| stat['player_key'] == player.player_key}[0]}
      end
      out = { id: trade.id, user_team_name: trade.league.team_name, user_team_key: trade.league.team_key, totrade_team_name: trade.team_name, totrade_team_key: trade.team_key, players_to_send: players_to_send, players_to_receive: players_to_receive}
      render json: out, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: {message: "Trade Not Found"}, status: 404

      #   if trades.length != 0
      #   trade_container = []
      #   trades.each do |trade|
      #     players_array = trade.sent_players.pluck(:player_key).concat(trade.received_players.pluck(:player_key))
      #     player_stats = Yahoo::Client.player_stats(updated_token, trade.league.league_key, players_array.join(','))
      #     sent_player_array = []
      #     received_player_array = []
      #     trade.sent_players.each do |player|
      #       sent_player_array << { player_key: player.player_key, player_name: player.player_name, stats: player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player.player_key }[0] }
      #     end
      #     trade.received_players.each do |player|
      #       received_player_array << { player_key: player.player_key, player_name: player.player_name, stats: player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player.player_key}[0]}
      #     end
      #     trade_container << { id: trade.id, team_key: trade.team_key, team_name: trade.team_name, sent_players: sent_player_array, received_players: received_player_array }
      #   end
      #   render json: trade_container, status: :ok
      # else
      #   render json: trades, status: :ok
      # end
    end

    def create #Specifiy Content-Type: application/json then pass it as array
      trade = Trade.new(league: League.find_by(league_key: user_params[:league_key]), team_key: trade_params[:team_key], team_name: trade_params[:team_name])
      players_to_send = params[:players_to_send].class == Array ? params[:players_to_send] : JSON.parse(params[:players_to_send])
      players_to_receive = params[:players_to_receive].class == Array ? params[:players_to_receive] : JSON.parse(params[:players_to_receive])
      if trade.save && players_to_send.present? && players_to_receive.present?
        players_to_send.each do |player|
          Trade.find_by(league_id: League.find_by(league_key: user_params[:league_key])).sent_players.create(player_key: player[:player_key], player_name: player[:player_name])
        end
        players_to_receive.each do |player|
          Trade.find_by(league_id: League.find_by(league_key: user_params[:league_key])).received_players.create(player_key: player[:player_key], player_name: player[:player_name])
        end
        render json: {message: "Trade Successful"}, status: :ok
      else
        render json: {message: "Trade Failed"}, status: 400
      end
    rescue TypeError 
      render json: {error: "Trade Failed"}, status: 400
    rescue ActionController::ParameterMissing
      render json: {error: "Missing Parameter"}, status: 400
    end

    private
    def trades
      current_user.leagues.find_by(league_key: user_params[:league_key]).trades
    end
    def trade
      Trade.find(params[:trade_id])
    end
    def trade_params
      params.require(:trade).permit(:team_key, :team_name)
    end
  end
end
