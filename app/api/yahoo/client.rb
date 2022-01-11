module Yahoo
    class Client
        #Returns list of leagues user is currently in for the year
        def self.leagues(access_token)
            response = Request.call('get', '/users;use_login=1/games;game_keys=nba/teams?format=json', access_token)
            resp_league_teams = response[:data]['fantasy_content']['users']['0']['user'][1]['games']['0']['game'][1]['teams']
            league_teams = []
            for i in (0...resp_league_teams['count']) do
                league_teams << {
                    team_key: resp_league_teams[i.to_s]['team'][0][0]['team_key'],
                    team_name: resp_league_teams[i.to_s]['team'][0][2]['name'],
                    logo_url: resp_league_teams[i.to_s]['team'][0][5]['team_logos'][0]['team_logo']['url']
                }
            end
            { teams: league_teams }
        end

        def self.league(access_token, league_key)
            response = Request.call('get', "/league/#{league_key}/settings?format=json", access_token)
            resp_league = response[:data]['fantasy_content']['league']
            temp_stats = resp_league[1]['settings'][0]['stat_categories']['stats']
            temp_roster = resp_league[1]['settings'][0]['roster_positions']
            { league: {
                league_key: resp_league[0]['league_key'],
                league_name: resp_league[0]['name'],
                num_teams: resp_league[0]['num_teams'],
                scoring_type: resp_league[0]['scoring_type'],
                roster_postions: temp_roster.map{ |x| [x['roster_position']['position'],x['roster_position']['count']]}.to_h,
                stat_categories: temp_stats.map{ |x| {
                    'stat_id': x['stat']['stat_id'],
                    'name': x['stat']['name'],
                    'display_name': x['stat']['display_name']
                }}
            }}
        end

        def self.roster()
        end

        def self.teams()
        end

        def self.player_stats()
        end
    end
end