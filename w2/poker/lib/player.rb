class Player

  attr_accessor :pot, :hand
  attr_reader :game, :deck, :initial_pot

  def initialize(game)
    @game = game
    @pot = @initial_pot = 20
    @deck = game.deck
    @hand = Hand.new(deck)
  end

  def make_bet
    puts "Your hand is #{hand}. Your pot is #{pot}."
    begin
      puts "R for raise, F for fold, S for see."
      bet = gets.chomp.upcase
      if bet == "R"
        puts "How much?"
        bet_size = gets.chomp.to_i
        raise InvalidInputError.new "Slow down, high roller." if bet_size > pot
        raise_bet(bet_size)
      elsif bet == "S"
        see
      elsif bet == "F"
        fold
      else
        raise InvalidInputError.new "That is not an R, F, or S."
      end
    rescue InvalidInputError => e
      p e.message
      retry
    end
  end

  def discard
    puts "Which cards? (Split them with space if many)"
    cards = gets.chomp.split(' ').map(&:to_i)
    hand.discard(cards)
  end

  def inspect
    "Player with hand of #{@hand}"
  end

  def actual_bet(num = 0)
      num + game.bet - (initial_pot - pot)
  end

  def raise_bet(num)
    @pot -= actual_bet(num)
    game.bet += num
    game.total_bet += actual_bet
    true
  end

  def see
    raise InvalidInputError.new "Slow down, high roller." if actual_bet > pot
    raise InvalidInputError.new "No one's made a bet yet" if game.bet == 0
    @pot -= actual_bet
    game.total_bet += actual_bet
    nil
  end

  def fold
    game.current_players.delete(self)
    nil
  end

end

class InvalidInputError < StandardError
end
