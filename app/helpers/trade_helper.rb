module TradeHelper
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

    def organized_default_roster(user)
        out = []
        player_info = user[:roster]
        player_stats = user[:stats]
      player_info.each do |player|
         stat = begin
          player_stats.find do |stat|
            stat['player_key'] == player[:player_key]
          end.except('player_key')
        rescue StandardError
          player_stats.find do |stat|
            stat['player_key'] == player[:player_key]
          end
        end
        out << {  player_key: player[:player_key], player_name: player[:player_name], player_team_full: player[:player_team_full], player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: stat}
      end
      out
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