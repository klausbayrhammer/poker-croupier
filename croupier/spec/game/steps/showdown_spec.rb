require_relative '../../spec_helper'
require 'card'

require 'poker_ranking'


describe Croupier::Game::Steps::Showdown do
  context "there are two players" do

    let(:game_state) do
      tournament_state = SpecHelper::MakeTournamentState.with(
          players: [fake_player, fake_player],
      )

      Croupier::Game::State.new(tournament_state).tap do |game_state|
        game_state.community_cards =
            ['3 of Diamonds', 'Jack of Clubs', 'Jack of Spades', 'Queen of Spades', 'King of Spades']
            .map { |name| PokerRanking::Card::by_name name }
      end
    end

    let(:showdown_step) { Croupier::Game::Steps::Showdown.new(game_state) }

    context "the winner is announced" do
      before :each do
        game_state.players.each { |player| player.total_bet = 1 }
      end

      it "should report the first player as a winner if it has a better hand" do
        set_hole_cards_for(0, 'Jack of Diamonds', 'Jack of Hearts')
        set_hole_cards_for(1, '4 of Clubs', 'Ace of Hearts')

        expect_winner_to_be_announced(game_state.players.first, 2)

        showdown_step.run
      end

      it "should report the second player as a winner if it has a better hand" do
        set_hole_cards_for(0, '4 of Clubs', 'Ace of Hearts')
        set_hole_cards_for(1, 'Jack of Diamonds', 'Jack of Hearts')

        expect_winner_to_be_announced(game_state.players.last, 2)

        showdown_step.run
      end

      it "should skip inactive players" do
        set_hole_cards_for(0, 'Jack of Diamonds', 'Jack of Hearts')
        set_hole_cards_for(1, '4 of Clubs', 'Ace of Hearts')

        game_state.players.first.fold

        expect_winner_to_be_announced(game_state.players.last, 2)

        showdown_step.run
      end

      it "should report multiple winners when players have identical hands" do
        set_hole_cards_for(0, '4 of Clubs', 'Jack of Hearts')
        set_hole_cards_for(1, '4 of Hearts', 'Jack of Diamonds')

        expect_winner_to_be_announced(game_state.players.first, 1)
        expect_winner_to_be_announced(game_state.players.last, 1)

        showdown_step.run
      end

      def expect_winner_to_be_announced(winner, amount = 0)
        allow(showdown_step).to receive(:show_hand)
        expect(game_state).to receive(:log_state).with(type: 'winner_announcement', message: "#{winner.name} won #{amount}")
      end
    end

    context "hands are revealed during showdown" do
      before :each do
        game_state.players.each { |player| player.total_bet = 1 }

        set_hole_cards_for(0, '4 of Clubs', 'Ace of Hearts')
        set_hole_cards_for(1, 'Jack of Diamonds', 'Jack of Hearts')
      end

      it "should show the cards of the first player" do
        expect_hand_to_be_announced_for game_state.first_player

        showdown_step.run
      end

      it "should not show cards if all but one player folded" do
        game_state.first_player.fold

        logger_mock = double
        allow(showdown_step).to receive(:log_winner)

        game_state.set_logger logger_mock

        showdown_step.run
      end

      def expect_hand_to_be_announced_for(player)
        hand = PokerRanking::Hand.new [*player.hole_cards, *game_state.community_cards]

        allow(showdown_step).to receive(:log_winner)
        expect(game_state).to receive(:log_state).with(type: 'showdown', message: "#{player.name} showed #{hand.cards_used.map{|card| card}.join(',')} making a #{hand.name}")
      end
    end

    context "the pot is transferred to the winner" do

      it "should transfer the entire pot when the winner is unique" do
        game_state.transfer_bet game_state.players.first, 100, :raise
        game_state.transfer_bet game_state.players.last, 100, :call

        set_hole_cards_for(0, 'Jack of Diamonds', 'Jack of Hearts')
        set_hole_cards_for(1, '4 of Clubs', 'Ace of Hearts')

        showdown_step.run

        expect(game_state.players.first.stack).to eq(1100)
        expect(game_state.players.last.stack).to eq(900)
        expect(game_state.pot).to eq(0)
      end

      it "should split the pot when the winner is not unique" do
        game_state.transfer_bet game_state.players.first, 100, :raise
        game_state.transfer_bet game_state.players.last, 100, :call

        set_hole_cards_for(0, '4 of Clubs', 'Jack of Hearts')
        set_hole_cards_for(1, '4 of Hearts', 'Jack of Diamonds')

        showdown_step.run

        expect(game_state.players.first.stack).to eq(1000)
        expect(game_state.players.last.stack).to eq(1000)
        expect(game_state.pot).to eq(0)
      end

      it "should give the remainder to the first few players when the pot is not divisible by number of players" do
        game_state.transfer_bet game_state.players.first, 101, :raise
        game_state.transfer_bet game_state.players.last, 100, :call

        set_hole_cards_for(0, '4 of Clubs', 'Jack of Hearts')
        set_hole_cards_for(1, '4 of Hearts', 'Jack of Diamonds')

        showdown_step.run

        expect(game_state.players.first.stack).to eq(1000)
        expect(game_state.players.last.stack).to eq(1000)
        expect(game_state.pot).to eq(0)
      end
    end
  end

  context "there are three players" do
    let(:game_state) do
      tournament_state = SpecHelper::MakeTournamentState.with(
          players: [fake_player, fake_player, fake_player],
      )

      Croupier::Game::State.new(tournament_state).tap do |game_state|
        game_state.community_cards =
            ['3 of Diamonds', 'Jack of Clubs', 'Jack of Spades', 'Queen of Spades', 'King of Spades']
            .map { |name| PokerRanking::Card::by_name name }
      end
    end

    let(:showdown_step) { Croupier::Game::Steps::Showdown.new(game_state) }

    context "there is a side pot" do
      it "should only reward the main_pot when winner is not in any side pots" do
        game_state.players[1].stack = 50

        game_state.transfer_bet game_state.players[0], 100, :raise
        game_state.transfer_bet game_state.players[1], 50, :allin
        game_state.transfer_bet game_state.players[2], 0, :fold

        set_hole_cards_for(0, '4 of Clubs', '5 of Hearts')
        set_hole_cards_for(1, '4 of Hearts', 'Jack of Diamonds')
        set_hole_cards_for(2, '4 of Spades', 'King of Diamonds')

        showdown_step.run

        expect(game_state.players[1].stack).to eq(100)
        expect(game_state.players[0].stack).to eq(950)
        expect(game_state.players[2].stack).to eq(1000)
      end

      it "should only reward the smaller side_pot first when two all-in players tie" do
        game_state.players[1].stack = 150
        game_state.players[2].stack = 50

        game_state.transfer_bet game_state.players[0], 500, :raise
        game_state.transfer_bet game_state.players[1], 150, :allin
        game_state.transfer_bet game_state.players[2], 50, :allin

        set_hole_cards_for(0, '4 of Spades', 'King of Diamonds')
        set_hole_cards_for(1, '4 of Hearts', 'Jack of Diamonds')
        set_hole_cards_for(2, '4 of Clubs', 'Jack of Hearts')

        showdown_step.run

        expect(game_state.players[0].stack).to eq(850)
        expect(game_state.players[1].stack).to eq(275)
        expect(game_state.players[2].stack).to eq(75)
      end
    end

    context "players are notified about the winners and revealed cards" do
      it "should send the game state with extra data to all players" do
        game_state.transfer_bet game_state.players[0], 100, :raise
        game_state.players[1].fold
        game_state.players[2].fold

        expect(game_state.players[2]).to receive(:showdown) do |game_state|
          expect(game_state[:players][0][:amount_won]).to eq(100)
          expect(game_state[:players][1]).not_to have_key(:hole_cards)
        end

        showdown_step.run
      end

      it "should include cards revealed" do
        game_state.transfer_bet game_state.players[0], 100, :raise
        game_state.transfer_bet game_state.players[1], 100, :raise
        game_state.transfer_bet game_state.players[2], 100, :raise


        set_hole_cards_for(0, '4 of Spades', 'King of Diamonds')
        set_hole_cards_for(1, '4 of Hearts', 'Jack of Diamonds')
        set_hole_cards_for(2, '4 of Clubs', 'Jack of Hearts')

        expect(game_state.players[0]).to receive(:showdown) do |game_state|
          expect(game_state[:players][1][:hole_cards].length).to eq(2)
        end

        showdown_step.run
      end
    end
  end

  def set_hole_cards_for(player_id, first_card, second_card)
    game_state.players[player_id].hole_card PokerRanking::Card::by_name(first_card)
    game_state.players[player_id].hole_card PokerRanking::Card::by_name(second_card)
  end

end
