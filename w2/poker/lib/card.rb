require 'colorize'
class Card

  attr_reader :suit, :number, :value

  NUMBER_TO_VALUE = { ace: 14, king: 13, queen: 12, jack: 11, ten: 10, nine: 9, eight: 8,
  seven: 7, six: 6, five: 5, four: 4, three: 3, two: 2 }

  def initialize(suit, number)
    @suit = suit
    @number = number
    @value = NUMBER_TO_VALUE[number]
  end

  def to_s
    "#{suit}".red + " #{number}"
  end

end
