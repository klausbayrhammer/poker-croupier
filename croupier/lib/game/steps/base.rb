class Croupier::Game::Steps::Base
  attr_reader :game_state

  def initialize(game_state)
    @game_state = game_state
  end
end