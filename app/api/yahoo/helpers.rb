module Yahoo
    class Helpers 
        def self.stat_categories
            @stat_categories = {
                '0'=> 'GP',
                '1'=> 'GS',
                '2'=> 'MIN',
                '3'=> 'FGA',
                '4'=> 'FGM',
                '5'=> 'FG%',
                '6'=> 'FTA',
                '7'=> 'FTM',
                '8'=> 'FT%',
                '9'=> '3PTA',
                '10'=> '3PTM',
                '11'=> '3PT%',
                '12'=> 'PTS',
                '13'=> 'OREB',
                '14'=> 'DREB',
                '15'=> 'REB',
                '16'=> 'AST',
                '17'=> 'ST',
                '18'=> 'BLK',
                '19'=> 'TO',
                '20'=> 'A/T',
                '21'=> 'PF',
                '22'=> 'DISQ',
                '23'=> 'TECH',
                '24'=> 'EJCT',
                '25'=> 'FF',
                '26'=> 'MPG',
                '27'=> 'DD',
                '28'=> 'TD',
                '9004003'=> 'FGM/A',
                '9007006'=> 'FTM/A',
                'player_key'=> 'player_key'
            }      
        end 

        def self.get_average(games_played, stat)
            gp = games_played.to_f
            if stat.include? "/"
                arr = stat.split "/"
                "#{ (arr[0].to_f / gp).round(2) } / #{ (arr[1].to_f / gp).round(2) }"
            else
                "#{ (stat.to_f / gp).round(2) }"

            end
        end
    end
end