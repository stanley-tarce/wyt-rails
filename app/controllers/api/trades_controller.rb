# frozen_string_literal: true

module Api
  class TradesController < ApplicationController
    prepend_before_action :authenticate_user!, only: %i[index create]
    before_action :check_token, only: %i[index create] # Order
    append_before_action :set_response_header, only: %i[index create]
    before_action :show_token_if_user, only: [:show]
    def index
      render json: trades, status: :ok
    end

    def show
      user_roster = Yahoo::Client.players(updated_token_from_trade_params, trade.league.team_key)
      totrade_roster = Yahoo::Client.players(updated_token_from_trade_params, trade.team_key)
      user_roster_keys = []
      user_other_roster_keys = []
      players_to_send = []
      players_to_receive = []
      user_other_roster = []
      totrade_other_roster = []
      players_array = trade.sent_players.pluck(:player_key).concat(trade.received_players.pluck(:player_key))

      user_roster[:data][:players].each do |player|
        user_roster_keys << player[:player_key].to_s
      end
      totrade_roster[:data][:players].each do |player|
        user_other_roster_keys << player[:player_key].to_s
      end

      user_player_stats = Yahoo::Client.player_stats(updated_token_from_trade_params, trade.league.league_key,
                                                user_roster_keys.join(','))
      other_user_player_stats = Yahoo::Client.player_stats(updated_token_from_trade_params, trade.league.league_key, user_other_roster_keys.join(','))
      trade.sent_players.each do |player|
        stat1 =  user_player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player.player_key }[0]
        roster = user_roster[:data][:players].select { |roster| roster[:player_key] == player.player_key }[0]
        players_to_send << { player_name: player.player_name, player_key: player.player_key,
                             player_team_full: roster[:player_team_full], player_team_abbr: roster[:player_team_abbr], player_number: roster[:player_number], player_positions: roster[:player_positions], player_image: roster[:player_image], stats: stat1.except('player_key') }
      end
      trade.received_players.each do |player|
        stat2 = other_user_player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player.player_key }[0]
        roster = totrade_roster[:data][:players].select { |roster| roster[:player_key] == player.player_key }[0]
        players_to_receive << { player_name: player.player_name, player_key: player.player_key,
                                player_team_full: roster[:player_team_full], player_team_abbr: roster[:player_team_abbr], player_number: roster[:player_number], player_positions: roster[:player_positions], player_image: roster[:player_image], stats: stat2.except('player_key') }
      end

      user_roster[:data][:players].each do |player|
        next if players_array.include? player[:player_key].to_s

        stat3 =  user_player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player[:player_key] }[0]
        user_other_roster << { player_name: player[:player_name], player_key: player[:player_key], player_team_full: player[:player_team_full], player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: stat3.except('player_key') }
      end
      totrade_roster[:data][:players].each do |player|
        next if players_array.include? player[:player_key].to_s

        stat4 = other_user_player_stats[:data][:player_stats].select { |stat| stat['player_key'] == player[:player_key] }[0]
        # puts "****************  old   #{stat4}"
        clean_stat4 = stat4.except('player_key') rescue stat4
        # puts "****************     #{clean_stat4}"
        totrade_other_roster << { player_name: player[:player_name], player_key: player[:player_key], player_team_full:   player[:player_team_full], player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: clean_stat4}
      end

      out = { id: trade.id, user_team_name: trade.league.team_name, user_team_key: trade.league.team_key,
              totrade_team_name: trade.team_name, totrade_team_key: trade.team_key, players_to_send: players_to_send, players_to_receive: players_to_receive, user_other_rosters: user_other_roster, totrade_other_rosters: totrade_other_roster }
      render json: out, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Trade Not Found' }, status: 404
    end

    # Specifiy Content-Type: application/json then pass it as array
    def create
      params.inspect
      trade = Trade.new(league: League.find_by(league_key: user_params[:league_key]),
                        team_key: trade_params[:team_key], team_name: trade_params[:team_name])
      players_to_send = params[:players_to_send].instance_of?(Array) ? params[:players_to_send] : JSON.parse(params[:players_to_send])
      players_to_receive = params[:players_to_receive].instance_of?(Array) ? params[:players_to_receive] : JSON.parse(params[:players_to_receive])
      if trade.save && players_to_send.present? && players_to_receive.present?
        players_to_send.each do |player|
          SentPlayer.create(player_key: player[:player_key], player_name: player[:player_name], trade: trade )
          # Trade.find_by(league_id: League.find_by(league_key: user_params[:league_key])).sent_players.create(
          #   player_key: player[:player_key], player_name: player[:player_name]
          # )
        end
        players_to_receive.each do |player|
          ReceivedPlayer.create([player_key: player[:player_key], player_name: player[:player_name], trade:trade])
          # Trade.find_by(league_id: League.find_by(league_key: user_params[:league_key])).received_players.create(
          #   player_key: player[:player_key], player_name: player[:player_name]
          # )
        end
        render json: { message: 'Trade Successful' }, status: :ok
      else
        render json: { message: 'Trade Failed' }, status: 400
      end
    rescue TypeError
      render json: { error: 'Trade Failed' }, status: 400
    rescue ActionController::ParameterMissing
      render json: { error: 'Missing Parameter' }, status: 400
    end

    def update
      players_to_send = params[:players_to_send].instance_of?(Array) ? params[:players_to_send] : JSON.parse(params[:players_to_send])
      players_to_receive = params[:players_to_receive].instance_of?(Array) ? params[:players_to_receive] : JSON.parse(params([:players_to_receive]))
      if players_to_send.present? && players_to_receive.present?
        trade.sent_players.destroy_all
        trade.received_players.destroy_all
        players_to_send.each do |player|
          trade.sent_players.create(player_key: player[:player_key], player_name: player[:player_name])
        end
        players_to_receive.each do |player|
          trade.received_players.create(player_key: player[:player_key], player_name: player[:player_name])
        end
        render json: { message: 'Trade Updated' }, status: :ok
      else
        render json: { message: 'Trade Update Failed' }, status: 400
      end
    end

    def delete
      if trade.destroy
        render json: { message: 'Trade Deleted' }, status: :ok
      else
        render json: { message: 'Trade Delete Failed' }, status: 400
      end
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
