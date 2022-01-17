# frozen_string_literal: true

module Api
  class TradesController < ApplicationController
    before_action :check_token # Order
    prepend_before_action :authenticate_user!
    append_before_action :set_response_header
    protect_from_forgery with: :null_session
    def index
      league = Yahoo::Client.league(updated_token, user_params[:league_key]) 
      @trades = current_user.leagues.find_by(league_id: user_params[:league_key]).trades if current_user.leagues.find_by(league_id: user_params[:league_key])
      leagues_array = []
      if @trades.present?
        leagues_array << { league_key: league[:data][:league][:league_key],
                           league_name: league[:data][:league][:league_name], num_teams: league[:data][:league][:num_teams],scoring_type: league[:data][:league][:scoring_type], trades: @trades }
      else
        leagues_array << { league_key: league[:data][:league][:league_key],
                           league_name: league[:data][:league][:league_name], num_teams: league[:data][:league][:num_teams],scoring_type: league[:data][:league][:scoring_type], trades: 'No Trades Found' }
      end
      render json: leagues_array, status: :ok
    end
  end
end
