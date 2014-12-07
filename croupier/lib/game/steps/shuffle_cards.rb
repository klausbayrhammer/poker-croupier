class Croupier::Game::Steps::ShuffleCards < Croupier::Game::Steps::Base
  def run
    game_state.deck.shuffle
  end
end