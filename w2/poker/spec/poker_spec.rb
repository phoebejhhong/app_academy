require 'rspec'
require 'poker.rb'

describe Card do

  subject(:card) { Card.new(:hearts, :king) }

  it "should have a suit and number" do
    expect(card.suit).to eq(:hearts)
    expect(card.number).to eq(:king)
  end

end

describe Deck do

  subject(:deck) { Deck.new }

  it "should have 52 cards" do
    expect(deck.deck.count).to eq(52)
  end

  it "should have 13 cards in a suit" do
    expect(deck.deck.count { |i| i.suit == :hearts }).to eq(13)
  end

  it "should have four suits" do
    suits = deck.deck.map { |i| i.suit }
    expect(suits.uniq.count).to eq(4)
  end

  it "should have four cards in a number" do
    expect(deck.deck.count { |i| i.number == :king }).to eq(4)
  end

  it "should have 13 numbers" do
    suits = deck.deck.map { |i| i.number }
    expect(suits.uniq.count).to eq(13)
  end

  it "should decrease in number after dealing" do
    deck.deal(5)
    expect(deck.deck.count).to be < 52
  end

  it "should choose cards randomly when dealing" do
    expect(deck.deal(5)).to_not eq(deck.deal(5))
  end

end

describe Hand do
  subject(:hand) { Hand.new(Deck.new) }
  it "has five cards when initiated" do
    expect(hand.hand.size).to eq(5)
  end

  it "removes a card when it's discarded" do
    first_hand = hand.hand
    discarded_card = hand.discard([0])
    expect(discarded_card).to eq([first_hand[0]])
    expect(hand.hand).to_not eq(first_hand)
  end

  it "can discard multiple cards" do
    first_hand = hand.hand
    discarded_cards = hand.discard([0, 1, 2])
    expect(discarded_cards).to eq([first_hand[0], first_hand[1], first_hand[2]])
    expect(hand.hand).to_not eq(first_hand)
  end

  it "should be able to figure out which hand is better" do
      sf_hand = Hand.new(Deck.new)
      sf_hand.hand = [ Card.new(:hearts, :king), Card.new(:hearts, :queen),
      Card.new(:hearts, :jack), Card.new(:hearts, :ten), Card.new(:hearts, :nine) ]
      rf_hand = Hand.new(Deck.new)
      rf_hand.hand = [ Card.new(:hearts, :king), Card.new(:hearts, :queen),
        Card.new(:hearts, :jack), Card.new(:hearts, :ten), Card.new(:hearts, :ace) ]

      fk_hand_high = Hand.new(Deck.new)
      fk_hand_high.hand = [ Card.new(:hearts, :nine), Card.new(:clubs, :nine),
         Card.new(:spades, :nine), Card.new(:diamonds, :nine), Card.new(:hearts, :ten) ]
      fk_hand_low = Hand.new(Deck.new)
      fk_hand_low.hand = [ Card.new(:hearts, :three), Card.new(:clubs, :three),
        Card.new(:spades, :three), Card.new(:diamonds, :three), Card.new(:hearts, :ten) ]

      fh_hand_high = Hand.new(Deck.new)
      fh_hand_high.hand = [ Card.new(:hearts, :ten), Card.new(:clubs, :ten),
        Card.new(:spades, :ten), Card.new(:diamonds, :king), Card.new(:hearts, :king) ]
      fh_hand_low = Hand.new(Deck.new)
      fh_hand_low.hand = [ Card.new(:hearts, :three), Card.new(:clubs, :three),
        Card.new(:spades, :three), Card.new(:diamonds, :four), Card.new(:hearts, :four) ]

      f_hand_high = Hand.new(Deck.new)
      f_hand_high.hand = [ Card.new(:hearts, :king), Card.new(:hearts, :queen),
        Card.new(:hearts, :three), Card.new(:hearts, :ten), Card.new(:hearts, :nine) ]
      f_hand_low = Hand.new(Deck.new)
      f_hand_low.hand = [ Card.new(:hearts, :two), Card.new(:hearts, :queen),
        Card.new(:hearts, :three), Card.new(:hearts, :ten), Card.new(:hearts, :nine) ]

      s_hand_high = Hand.new(Deck.new)
      s_hand_high.hand = [ Card.new(:hearts, :king), Card.new(:clubs, :queen),
        Card.new(:spades, :jack), Card.new(:diamonds, :ten), Card.new(:hearts, :nine) ]
      s_hand_low = Hand.new(Deck.new)
      s_hand_low.hand = [ Card.new(:hearts, :eight), Card.new(:clubs, :queen),
        Card.new(:spades, :jack), Card.new(:diamonds, :ten), Card.new(:hearts, :nine) ]

      tk_hand_high = Hand.new(Deck.new)
      tk_hand_high.hand = [ Card.new(:hearts, :nine), Card.new(:clubs, :nine),
        Card.new(:spades, :nine), Card.new(:diamonds, :two), Card.new(:hearts, :ten) ]
      tk_hand_low = Hand.new(Deck.new)
      tk_hand_low.hand = [ Card.new(:hearts, :three), Card.new(:clubs, :three),
        Card.new(:spades, :three), Card.new(:diamonds, :five), Card.new(:hearts, :ten) ]

      tp_hand_high = Hand.new(Deck.new)
      tp_hand_high.hand = [ Card.new(:hearts, :nine), Card.new(:clubs, :nine),
      Card.new(:spades, :ace), Card.new(:diamonds, :ace), Card.new(:hearts, :ten) ]
      tp_hand_low = Hand.new(Deck.new)
      tp_hand_low.hand = [ Card.new(:hearts, :three), Card.new(:clubs, :three),
      Card.new(:spades, :five), Card.new(:diamonds, :five), Card.new(:hearts, :ten) ]

      op_hand_high = Hand.new(Deck.new)
      op_hand_high.hand = [ Card.new(:hearts, :nine), Card.new(:clubs, :nine),
      Card.new(:spades, :five), Card.new(:diamonds, :two), Card.new(:hearts, :ten) ]
      op_hand_low = Hand.new(Deck.new)
      op_hand_low.hand = [ Card.new(:hearts, :three), Card.new(:clubs, :three),
      Card.new(:spades, :four), Card.new(:diamonds, :five), Card.new(:hearts, :ten) ]

      hc_hand_high = Hand.new(Deck.new)
      hc_hand_high.hand = [ Card.new(:hearts, :ace), Card.new(:clubs, :king),
      Card.new(:spades, :nine), Card.new(:diamonds, :two), Card.new(:hearts, :ten) ]
      hc_hand_low = Hand.new(Deck.new)
      hc_hand_low.hand = [ Card.new(:hearts, :four), Card.new(:clubs, :seven),
      Card.new(:spades, :three), Card.new(:diamonds, :five), Card.new(:hearts, :ten) ]

      hands = [rf_hand, sf_hand, fk_hand_high, fk_hand_low, fh_hand_high, fh_hand_low, f_hand_high,
      f_hand_low, s_hand_high, s_hand_low, tk_hand_high, tk_hand_low, tp_hand_high, tp_hand_low,
      op_hand_high, op_hand_low, hc_hand_high, hc_hand_low]

      hands.each_with_index do |hand, i|
        unless i == 17
          expect(hand.value_higher?(hands[i + 1])).to eq(1)
        end
      end

  end

end

describe Player do
  let(:game) { Game.new(2) }
  subject(:player) { game.players.first }

  it "should have a hand and pot" do
    expect(player.hand).to be_a(Hand)
    expect(player.pot).to be(20)
  end

  # it "should discard cards" do
  #   first_hand = player.hand.hand
  #   player.discard(0)
  #   expect(player.hand.hand).to_not eq(first_hand)
  # end

  it "should raise as the first player" do
    player.raise_bet(5)
    expect(player.pot).to eq(15)
    expect(game.bet).to eq(5)
  end

  it "should see bets" do
    first_player = game.players.last
    first_player.raise_bet(5)
    player.see
    expect(player.pot).to eq(15)
    expect(game.bet).to eq(5)
  end

  it "should raise bets" do
    first_player = game.players.last
    first_player.raise_bet(5)
    player.raise_bet(5)
    expect(player.pot).to eq(10)
    expect(game.bet).to eq(10)
  end

  it "should fold" do
    player.fold
    expect(game.current_players).to_not include(player)
  end

end

describe Game do

  subject(:game) { Game.new(2) }

  it "should have players and a deck" do
    expect(game.players.count).to be(2)
    expect(game.players.first).to be_a(Player)
    expect(game.deck).to be_a(Deck)
  end

end
