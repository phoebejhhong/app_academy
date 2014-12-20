class Hand

  attr_accessor :hand
  attr_reader :deck

  def initialize(deck)
    @hand = deck.deal(5)
    @deck = deck
  end

  def to_s
    hand.join(" ")
  end

  def discard(cards)
    deleted_cards = []
    cards.each do |index|
      deleted_cards << hand[index]
    end
    @hand -= deleted_cards
    @hand += deck.deal(cards.size)
    deleted_cards
  end

  def value_higher?(other_hand)
    self_win_value = win_value
    other_win_value = other_hand.win_value
    if self_win_value > other_win_value
      1
    elsif self_win_value < other_win_value
      -1
    elsif [8, 4, 3, 2].include?(self_win_value)
      pair_card_higher?(other_hand)
    else
      card_higher?(other_hand)
    end
  end

  def win_value
    return 9 if straight? && flush?
    return 8 if of_a_kind?(4)
    return 7 if of_a_kind?(3) && of_a_kind?(2)
    return 6 if flush?
    return 5 if straight?
    return 4 if of_a_kind?(3)
    return 3 if two_pair?
    return 2 if of_a_kind?(2)
    return 1
  end

  def card_higher?(other_hand)
    self_hand_values = hand.map { |card| card.value }.sort.reverse
    other_hand_values = other_hand.hand.map { |card| card.value }.sort.reverse
    self_hand_values.each_with_index do |card, index|
      return 1 if card > other_hand_values[index]
      return -1 if card < other_hand_values[index]
    end
    0
  end

  def pair_card_higher?(other_hand)
    self_card_counts = self.card_counts.to_a.sort_by {|i| i.last}.reverse
    other_card_counts = other_hand.card_counts.to_a.sort_by {|i| i.last}.reverse
    self_card_counts.each_with_index do |card, index|
      return 1 if card.first > other_card_counts[index].first
      return -1 if card.first < other_card_counts[index].first
    end
    0
  end

  def card_counts
    hand_values = hand.map { |card| card.value }
    value_count = Hash.new(0)
    hand_values.each { |value| value_count[value] += 1 }
    value_count
  end

  def straight?
    hand_values = hand.map { |card| card.value }.sort
    return true if hand_values == [2, 3, 4, 5, 14]
    hand_values.each_cons(2) do |x, y|
      return false unless y - x == 1
    end
    true
  end

  def flush?
    hand.map { |card| card.suit }.uniq.count == 1
  end

  def of_a_kind?(num)
    card_counts.values.include?(num)
  end

  def two_pair?
    hand_values = hand.map { |card| card.value }
    hand_values.uniq.size == 3
  end

end
