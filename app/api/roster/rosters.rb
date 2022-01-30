module Roster
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
end