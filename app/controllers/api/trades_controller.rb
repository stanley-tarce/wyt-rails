# frozen_string_literal: true

module Api
  class TradesController < ApplicationController
    prepend_before_action :authenticate_user!, only: %i[index create owner delete update]
    before_action :check_token, only: %i[index create owner delete update] # Order
    append_before_action :set_response_header, only: %i[index create owner delete update]
    def index
      render json: trades.by_ascending, status: :ok
    end

    def show
      token = updated_token_from_trade_params
      league = Yahoo::Client.league(token, trade.league.league_key)
      user = roster_stats(trade.league.team_key, trade.league.league_key, token)
      partner = roster_stats(trade.team_key, trade.league.league_key, token)
      players_array = trade.sent_players.pluck(:player_key).concat(trade.received_players.pluck(:player_key))
      players_to_send = organized_roster_from_db(trade.sent_players, user)
      players_to_receive = organized_roster_from_db(trade.received_players, partner)
      user_other_roster = organized_roster_from_api(user, players_array)
      partner_other_roster = organized_roster_from_api(partner, players_array)
      out = { id: trade.id, league_name: trade.league.league_name, user_team_name: trade.league.team_name,
              user_team_key: trade.league.team_key, totrade_team_name: trade.team_name, totrade_team_key: trade.team_key, totrade_team_logo: trade.team_logo, players_to_send: players_to_send, players_to_receive: players_to_receive, user_other_rosters: user_other_roster, totrade_other_rosters: partner_other_roster, league: league[:data][:league] }
      render json: out, status: :ok
    end

   

    # Specifiy Content-Type: application/json then pass it as array
    def create
      trade = Trade.new(league: League.find_by(league_key: user_params[:league_key]),
                        team_key: trade_params[:team_key], team_name: trade_params[:team_name], team_logo: trade_params[:team_logo])
      players_to_send = params[:players_to_send].instance_of?(Array) ? params[:players_to_send] : JSON.parse(params[:players_to_send])
      players_to_receive = params[:players_to_receive].instance_of?(Array) ? params[:players_to_receive] : JSON.parse(params[:players_to_receive])
      if trade.save && players_to_send.present? && players_to_receive.present?
        players_to_send.each do |player|
          SentPlayer.create(player_key: player[:player_key], player_name: player[:player_name], trade: trade)
        end
        players_to_receive.each do |player|
          ReceivedPlayer.create([player_key: player[:player_key], player_name: player[:player_name], trade: trade])
        end
        render json: { message: 'Trade Successful', id: trade.id }, status: :ok
      else
        render json: { message: 'Trade Failed' }, status: 400
      end
    rescue TypeError
      render json: { error: 'Trade Failed' }, status: 400
    rescue ActionController::ParameterMissing
      render json: { error: 'Missing Parameter' }, status: 400
    rescue MethodError
      render json: { error: 'Failed to fetch Trade Data' }, status: 400
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
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Trade Not Found' }, status: 404
    end

    def owner
      user_from_trade_id = trade.league.user
      if user_from_trade_id.email == current_user.email
        render json: { message: 'true' }, status: :ok
      else
        render json: { message: 'false' }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Trade Not Found' }, status: 404
    end

    private

    def trades
      current_user.leagues.find_by(league_key: user_params[:league_key]).trades
    end

    def trade
      Trade.find(params[:trade_id])
    end

    def trade_params
      params.require(:trade).permit(:team_key, :team_name, :team_logo)
    end

    def roster_stats(team_key, league_key, token)
      roster = []
      response_roster = Yahoo::Client.players(token, team_key)
      stats = Yahoo::Client.player_stats(token, league_key,
                                         response_roster[:data][:players].pluck(:player_key).join(','))
      if response_roster[:data][:players].present? && stats[:data][:player_stats].present?
        { roster: response_roster[:data][:players],
          stats: stats[:data][:player_stats] }
      end
    rescue StandardError
    end

    def organized_roster_from_db(trade, user)
      return [] if trade.nil? && user.nil?
      container = []
      trade.each do |player|
        stat = begin
          user[:stats].find do |stat|
            stat['player_key'] == player.player_key
          end.except('player_key')
        rescue StandardError
          user[:stats].find do |stat|
            stat['player_key'] == player.player_key
          end
        end
        roster = user[:roster].find { |roster| roster[:player_key] == player.player_key }
        if !(roster.nil? || stat.nil?)
          container << { player_name: player.player_name, player_key: player.player_key,
                         player_team_full: roster[:player_team_full], player_team_abbr: roster[:player_team_abbr], player_number: roster[:player_number], player_positions: roster[:player_positions], player_image: roster[:player_image], stats: stat }
          else
            container << dropped(player)
        end
      end
      container
    end

    def organized_roster_from_api(user, keys_from_db)
      return [] if keys_from_db.count == 0 && user.nil?

      container = []
      user[:roster].each do |player|
        next if keys_from_db.include? player[:player_key].to_s

        stat = begin
          user[:stats].find do |stat|
            stat['player_key'] == player[:player_key]
          end.except('player_key')
        rescue StandardError
          user[:stats].find do |stat|
            stat['player_key'] == player[:player_key]
          end
        end
        container << { player_key: player[:player_key], player_name: player[:player_name],
                       player_team_full: player[:player_team_full], player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: stat }
      end
      container
    end

    def dropped(player)
      { player_name: 'Dropped', player_key: player.player_key, player_team_full: '-', player_team_abbr: '-', player_number: '-', player_positions: '-', player_image: '-', stats: {
        'GP' => '-',
        'FGM/A' => '- / -',
        'FG%' => '-',
        'FTM/A' => '- / -',
        'FT%' => '-',
        '3PTM' => '-',
        'PTS' => '-',
        'REB' => '-',
        'AST' => '-',
        'ST' => '-',
        'BLK' => '-',
        'TO' => '-'
      } }
    end
  end
end
