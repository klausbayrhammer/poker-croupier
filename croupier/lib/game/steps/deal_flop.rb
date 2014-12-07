class Croupier::Game::Steps::DealFlop < Croupier::Game::Steps::Base
  def run
    3.times do
      Croupier::Game::Steps::DealCommunityCard.new(game_state).run
    end
  end

end
