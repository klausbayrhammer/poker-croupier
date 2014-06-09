require 'yaml'
require 'open3'

class Croupier::Tournament::Controller
  def initialize
    @players = []
    @processes = []
  end

  def sit_and_go_logfile(log_file)
    Croupier::log_file = log_file
    @log_file = log_file
  end

  def tournament_logfile(log_file)
    @tournament_logfile = "#{log_file}.json"
  end

  def register_git_player(name, directory)
    @players << { type: :git, name: name, directory: directory }
  end

  def register_rest_player(name, url)
    @players << { type: :rest, name: name, url: url }
  end

  def start_tournament
    reset_players_to_git_master

    sit_and_go_controller = Croupier::SitAndGo::Controller.new
    sit_and_go_controller.logger = Croupier::LogHandler::Json.new("#{Croupier::log_file}.json")

    start_players(sit_and_go_controller)

    wait_for_players_to_start(sit_and_go_controller)

    ranking = sit_and_go_controller.start_sit_and_go

    persist_ranking_and_points(ranking)

    stop_players
    wait_for_all_processes_to_stop
  end


  private

  def git_players
    @players.select { |player| player[:type] == :git }
  end

  def rest_players
    @players.select { |player| player[:type] == :rest }
  end

  def persist_ranking_and_points(ranking)
    tournament_round = Croupier::Tournament::Persister.load_last_from(@tournament_logfile)

    tournament_round.update_with ranking
    tournament_round.mark_active @players

    git_players.each do |player|
      tournament_round.data['ranking'][player[:name]]['log_file'] = player_log player
      tournament_round.data['ranking'][player[:name]]['commit'] = player[:commit]
    end

    rest_players.each do |player|
      tournament_round.data['ranking'][player[:name]]['log_file'] = ''
      tournament_round.data['ranking'][player[:name]]['commit'] = 'unsupported for rest players'
    end

    tournament_round.data['time'] = Time.new.strftime "%H:%M"

    Croupier::Tournament::Persister.append_to(@tournament_logfile, tournament_round)
  end

  def wait_for_players_to_start(sit_and_go_controller)
    max_iterations_left = 90
    until sit_and_go_controller.players_running? or max_iterations_left < 0
      Croupier::logger.info "Waiting for players to start"
      sleep(1)
      max_iterations_left -= 1
    end
    Croupier::logger.info "Players are running"
  end

  def reset_players_to_git_master
    git_players.each do |player|
      Croupier::logger.info "Reseting #{player[:name]} to origin/master"
      `cd #{player[:directory]} && git fetch origin && git reset --hard origin/master && git clean -d -f`
      player[:commit], _, _ = Open3.capture3("cd #{player[:directory]} && git rev-parse HEAD")
      player[:commit].strip!
    end
  end

  def wait_for_all_processes_to_stop
    @processes.each do |pid|
      Process.wait pid
    end
  end

  def stop_players
    git_players.each do |player|
      @processes << Process.spawn("bash #{player[:directory]}/stop.sh")
    end
  end

  def start_players(sit_and_go_controller)
    @players.each do |player|
      if player[:type] == :git
        config = YAML.load_file("#{player[:directory]}/config.yml")
        @processes << Process.spawn("bash #{player[:directory]}/start.sh 2>&1 | tee #{player_log(player)}")
        sit_and_go_controller.register_rest_player player[:name], config["url"]
      elsif
        sit_and_go_controller.register_rest_player player[:name], player[:url]
      end
    end
  end

  def player_log(player)
    "#{@log_file}_player_#{to_file_name(player[:name])}.log"
  end

  def to_file_name(name)
    name.gsub(/[^a-zA-Z0-9]/, '_').downcase
  end
end
