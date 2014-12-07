
class Croupier::Game::Steps::Betting::PreFlop < Croupier::Game::Steps::Betting::Step

  private

  def build_betting_state
    game_state.first_player.force_bet game_state.small_blind
    game_state.second_player.force_bet game_state.big_blind
    Croupier::Game::Steps::Betting::State.new(game_state).tap do |state|
      state.minimum_raise = 0
    end
  end

  def minimum_number_of_bets
    @betting_players.length + 2
  end

end