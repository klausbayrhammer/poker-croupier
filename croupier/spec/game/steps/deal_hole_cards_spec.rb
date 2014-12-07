require_relative '../../spec_helper.rb'
require 'card'

describe Croupier::Game::Steps::DealHoleCards do
  let(:game_state) { SpecHelper::MakeTournamentState.with players: [fake_player, fake_player] }
  let(:cards) { ['6 of Diamonds', 'Jack of Hearts', 'Ace of Spades', 'King of Clubs'].map { |name| PokerRanking::Card::by_name name } }

  before :each do
    deck = double("Deck")
    allow(deck).to receive(:next_card!).and_return(*cards)

    expect(game_state).to receive(:log_state).exactly(5).times

    allow(Croupier::Deck).to receive(:new).and_return(deck)
  end

  it "should deal two cards to all of the players" do
    expect(game_state.players[1]).to receive(:hole_card).once.with(cards[0])
    expect(game_state.players[0]).to receive(:hole_card).once.with(cards[1])
    expect(game_state.players[1]).to receive(:hole_card).once.with(cards[2])
    expect(game_state.players[0]).to receive(:hole_card).once.with(cards[3])

    Croupier::Game::Steps::DealHoleCards.new(game_state).run
  end

  it "should still start with the first player after the button has moved" do
    game_state.next_round!

    expect(game_state.players[0]).to receive(:hole_card).once.with(cards[0])
    expect(game_state.players[1]).to receive(:hole_card).once.with(cards[1])
    expect(game_state.players[0]).to receive(:hole_card).once.with(cards[2])
    expect(game_state.players[1]).to receive(:hole_card).once.with(cards[3])

    Croupier::Game::Steps::DealHoleCards.new(game_state).run
  end

  it "should skip players with no chips left" do
    game_state.register_player fake_player

    game_state.players[1].stack = 0

    expect(game_state.players[2]).to receive(:hole_card).once.with(cards[0])
    expect(game_state.players[0]).to receive(:hole_card).once.with(cards[1])
    expect(game_state.players[2]).to receive(:hole_card).once.with(cards[2])
    expect(game_state.players[0]).to receive(:hole_card).once.with(cards[3])

    Croupier::Game::Steps::DealHoleCards.new(game_state).run
  end
end