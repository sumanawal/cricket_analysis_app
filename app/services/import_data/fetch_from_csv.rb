# frozen_string_literal

# Fetch Data From CSV
module ImportData
  class FetchFromCsv
    attr_reader :filename, :csv_data, :infos, :flat_infos, :team_ids, :ball_by_ball_detail

    def initialize(filename:)
      @filename = filename
    end

    def execute
      read_csv
      game = create_game
      match_info = create_match_infomation(game)
      create_match_detail(game, match_info)
    end

    private

    def read_csv
      @csv_data = CSV.read(filename)
      @infos = csv_data.select { |data| data[0] == 'info' }
      @flat_infos = infos.map { |data| [data[1].downcase, data[2].downcase]}.to_h
      @ball_by_ball_detail = @csv_data.select{ |data| data[0] == 'ball' }
    end

    def create_game
      game = Game.new
      home_team_name, away_team_name = teams
      home_team = Team.find_or_create_by(name: home_team_name.downcase)
      away_team = Team.find_or_create_by(name: away_team_name.downcase)
      @team_ids = [home_team.id, away_team.id]
      game_type = match_type
      game.assign_attributes(
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        title: flat_infos[find_match_type.downcase],
        season: flat_infos['season'],
        start_date: dates[:start_date],
        end_date: dates[:end_date],
        number_of_days: dates[:number_of_days],
        match_type_id: match_type.id,
        gender: flat_infos['gender']
      )
      game.save!
      game
    end

    def create_match_infomation(game)
      match_info = game.match_informations.new
      principal_umpire, cheif_umpire = umpires
      match_info.assign_attributes(
        match_number: flat_infos['match_number'],
        venue: flat_infos['venue'],
        city: flat_infos['city'],
        toss_winner_id: Team.find_by(name: flat_infos['toss_winner'].downcase).id,
        toss_decision: flat_infos['toss_decision'],
        player_of_match: flat_infos['player_of_match'],
        principal_umpire: principal_umpire,
        cheif_umpire: cheif_umpire,
        tv_umpire: flat_infos['tv_umpire'],
        match_refree: flat_infos['match_referee'],
        reserve_umpire: flat_infos['reserve_umpire'],
        winner_id: Team.find_by(name: flat_infos['winner'].downcase).id,
        winner_inning: flat_infos['winner_innings'],
        win_type: winner_type,
        win_by: flat_infos['winner_type']
      )
      match_info.save!
      match_info
    end

    def create_match_detail(game, match_info)
      ball_by_ball_detail.each do |ball_detail|
        match_detail = MatchDetail.new
        match_detail.game_id = game.id
        match_detail.match_information_id = match_info.id
        over, ball = over_and_ball(ball_detail)
        batting_team = Team.find_by(name: ball_detail[3].downcase)
        match_detail.assign_attributes(
          over_number: over,
          ball_number: ball,
          inning_number: ball_detail[1],
          batting_team_id: batting_team.id,
          balling_team_id: balling_team_id(batting_team.id),
          striker_batsman: ball_detail[4],
          non_striker_batsman: ball_detail[5],
          baller: ball_detail[6],
          run_count: ball_detail[7],
          extra_run: ball_detail[8],
          wkt_type: ball_detail[9],
          wkt_taker: ball_detail[10]
        )
        match_detail.save!
      end
    end

    def dates
      date_range = infos.map do |data| 
        data[2].to_date if data[1] == 'date'
      end.compact.sort
      { start_date: date_range.first, end_date: date_range.last, number_of_days: date_range.count }
    end

    def teams
      infos.map do |data|
        data[2] if data[1] == 'team'
      end
    end

    def match_type
      MatchType.find_or_create_by(name: find_match_type.downcase) if find_match_type.present?
    end

    def find_match_type
      (infos.map { |data| data[1] } - game_keys)[0]
    end

    def game_keys
      %w[team gender season date match_number venue city 
        toss_winner toss_decision player_of_match umpire 
        reserve_umpire tv_umpire match_referee winner 
        winner_innings winner_runs winner_wickets]
    end

    def winner_type
      (['winner_wickets', 'winner_runs'] & flat_infos.keys).first
    end

    def over_and_ball(ball_detail)
      ball_detail[2].split('.')
    end

    def balling_team_id(batting_team_id)
      (team_ids - [batting_team_id]).first
    end

    def umpires
      infos.map { |data| data[2] if data[1] == 'umpire' }
    end
  end
end
