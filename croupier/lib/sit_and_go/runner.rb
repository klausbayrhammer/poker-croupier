class Croupier::SitAndGo::Runner

  def initialize
    @tournament_state = Croupier::SitAndGo::State.new
  end

  def register_player(player)
    @tournament_state.register_player player
  end

  def logger=(logger)
    @tournament_state.logger= logger
  end

  def logger
    @tournament_state.logger
  end

  def start_sit_and_go
    @tournament_state.select_dealer_randomly
    ranking = Croupier::SitAndGo::Ranking.new(@tournament_state)
    while @tournament_state.number_of_active_players_in_tournament >= 2 do
      Croupier::Game::Runner.new.run(@tournament_state)
      ranking.eliminate
      @tournament_state.next_round!
    end
    ranking.add_winner
    ranking
  end

  def players_running?
    @tournament_state.players_running?
  end
end
