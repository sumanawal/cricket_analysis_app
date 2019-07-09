# frozen_string_literal

# Import data from CSV file
class ImportDataFromCsv
  attr_reader :filename, :csv_data, :infos, :flat_infos

  def initialize(filename:)
    @filename = filename
  end

  def execute
    read_csv
    create_game
  end

  private

  def read_csv
    @csv_data = CSV.read(filename)
    @infos = csv_data.select { |data| data[0] == 'info' }
    @flat_infos = infos.map { |data| [data[1].downcase, data[2].downcase]}.to_h
  end

  def create_game
    game = Game.new
    home_team_name, away_team_name = teams
    home_team = Team.find_or_create_by(name: home_team_name.downcase)
    away_team = Team.find_or_create_by(name: away_team_name.downcase)
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
end
