class Deck

  SUITS = [:hearts, :clubs, :spades, :diamonds]
  NUMBERS = [:ace, :king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two ]

  attr_accessor :deck

  def initialize
    @deck = []
    SUITS.each do |suit|
      NUMBERS.each do |number|
        deck << Card.new(suit, number)
      end
    end
  end

  def deal(num)
    random_cards = deck.sample(num)
    @deck -= random_cards
    random_cards
  end

end
