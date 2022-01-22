require_relative './helpers.rb'

module Yahoo
    class Client
        #Returns list of leagues user is currently in for the year
        def self.leagues(access_token)
            response = Request.call('get', '/users;use_login=1/games;game_keys=nba/teams?format=json', access_token)
            if response[:code] == 200
                resp_league_teams = response[:data]['fantasy_content']['users']['0']['user'][1]['games']['0']['game'][1]['teams']
                league_teams = []
                for i in 0...resp_league_teams['count'].to_i do
                        if resp_league_teams[i.to_s]['team'].dig(0,0,'team_key')
                            league_teams << {
                                team_key: resp_league_teams[i.to_s]['team'][0][0]['team_key'],
                                team_name: resp_league_teams[i.to_s]['team'][0][2]['name'],
                                logo_url: resp_league_teams[i.to_s]['team'][0][5]['team_logos'][0]['team_logo']['url']
                            }
                        end
                end
                return { code: response[:code], response: response[:status], data: {teams: league_teams } }
            else
                { code: response[:code], response: response[:status], data: response[:data] }
            end
            
        end

        def self.league(access_token, league_key)
            response = Request.call('get', "/league/#{league_key}/settings?format=json", access_token)
            if response[:code] == 200
                resp_league = response[:data]['fantasy_content']['league']
                temp_stats = resp_league[1]['settings'][0]['stat_categories']['stats']
                temp_roster = resp_league[1]['settings'][0]['roster_positions']
                league =  {
                    league_key: resp_league[0]['league_key'],
                    league_name: resp_league[0]['name'],
                    num_teams: resp_league[0]['num_teams'],
                    scoring_type: resp_league[0]['scoring_type'],
                    roster_postions: temp_roster.map{ |i| [i['roster_position']['position'],i['roster_position']['count']]}.to_h,
                }
                return { code: response[:code], response: response[:status], data: {league: league} }
            else
                { code: response[:code], response: response[:status], data: response[:data] }
            end
        end

        def self.players(access_token, team_key)
            response = Request.call('get', "/team/#{team_key}/roster?format=json", access_token)
            puts response
            if response[:code] == 200
                resp_players = response[:data]['fantasy_content']['team'][1]['roster']['0']['players']
                players = []
       
                for i in (0...resp_players['count']) do
                    flattened_player_info = {}
                    resp_players[i.to_s]['player'][0].each{|j| j.each{|k,v| flattened_player_info[k] = v }}
                    players << {
                        player_key: flattened_player_info['player_key'],
                        player_name: flattened_player_info['name']['full'],
                        player_team_full: flattened_player_info['editorial_team_full_name'],
                        player_team_abbr: flattened_player_info['editorial_team_abbr'],
                        player_number: flattened_player_info['uniform_number'],
                        player_positions: flattened_player_info['display_position'],
                        player_image: flattened_player_info['image_url'],
                    }
                end
                return { code: response[:code], response: response[:status], data: {players: players} }
            else
                { code: response[:code], response: response[:status], data: response[:data] }
            end

            
        end

        def self.teams_in_league(access_token, league_key)
            response = Request.call('get', "/league/#{league_key}/teams?format=json", access_token)
            if response[:code] == 200
                resp_league_teams = response[:data]['fantasy_content']['league'][1]['teams']
                league_teams = []
                for i in (0...resp_league_teams['count']) do
                    flattened_team_info = {}
                    resp_league_teams[i.to_s]['team'][0].each{|j| j.each{|k,v| flattened_team_info[k] = v }}
                    league_teams << {
                        team_key: flattened_team_info['team_key'],
                        team_name: flattened_team_info['name'],
                        team_logo_url: flattened_team_info['team_logos'][0]['team_logo']['url'],
                        manager: flattened_team_info['managers'].map.with_index{|x, j| [j,x['manager']['nickname']]}.to_h
                    }
                end
                return { code: response[:code], response: response[:status], data: {league_teams: league_teams} }
            else
                { code: response[:code], response: response[:status], data: response[:data] }
            end
        end

        def self.player_stats(access_token, league_key, player_keys)
            response_for_gp = Request.call('get', "/players;player_keys=#{player_keys}/stats?format=json", access_token)
            if response_for_gp[:code] != 200
                return { code: response_for_gp[:code], response: response_for_gp[:status], data: response_for_gp[:data] }
            else
                #API call for Total Games Played by Player
                resp_player_stats1 = response_for_gp[:data]['fantasy_content']['players']
                player_stats_arr = []
                for i in (0...resp_player_stats1['count']) do
                    flattened_player_stats = {}
                    #get player key
                    resp_player_stats1[i.to_s]['player'][0].each{|j| j.each{|k,v| k == 'player_key' ? flattened_player_stats[k] = v : next }}
                    #get games played
                    resp_player_stats1[i.to_s]['player'][1]['player_stats']['stats'].each{|x| x['stat']['stat_id'] == '0' ? flattened_player_stats['0'] = x['stat']['value'] : next}
                    player_stats_arr << flattened_player_stats
                end

                #API call for league-specific stats of player
                response_for_stats = Request.call('get', "/league/#{league_key}/players;player_keys=#{player_keys}/stats?format=json", access_token)
                if response_for_stats[:code] != 200
                    return { code: response_for_stats[:code], response: response_for_stats[:status], data: response_for_stats[:data] }
                else
                    resp_player_stats2 = response_for_stats[:data]['fantasy_content']['league'][1]['players']
                    for i in (0...resp_player_stats2['count']) do
                        resp_player_stats2[i.to_s]['player'][1]['player_stats']['stats'].each{|x| player_stats_arr[i][x['stat']['stat_id']] = x['stat']['value']}
                    end
                end

                player_stats_arr.each do |x| 
                    #calculate average stat values based on games played
                    x.each{|k,v| x[k] = Helpers.get_average(x['0'],v) unless %w[5 8 0 1 11 20 26 27 28 player_key].include? k }
                    #replace stat_id codes with readable abbreviations
                    x.transform_keys!{|k| Helpers.stat_categories[k]} 
                end


                return { code: response_for_stats[:code], response: response_for_stats[:status], data: {player_stats: player_stats_arr} }
            end
        end
        
    end
end