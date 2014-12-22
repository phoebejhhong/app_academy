require_relative 'deck.rb'
require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'hand.rb'

class Game

  attr_accessor :deck, :players, :current_players, :bet, :total_bet

  def initialize(num_of_players)
    @deck = Deck.new
    @players = @current_players = Array.new(num_of_players) { Player.new(self) }
    @bet = 0
    @total_bet = 0
  end

  def run
    bet_phase
    discard_phase
    bet_phase
    win_phase
  end

  def bet_phase
    raised = true
    until raised == false
      raised = false
      current_players.each do |player|
        raised = true if player.make_bet
        return if current_players.count == 1
        puts "The number of players is #{current_players.count}."
        puts "The current bet is #{bet} and total bet is #{total_bet}"
        puts "Your pot is #{player.pot}."
      end
    end
  end

  def discard_phase
    if current_players.count > 1
      current_players.each do |player|
        player.discard
      end
    end
  end

  def win_phase
    current_players.sort! {|p1, p2| p1.hand.value_higher?(p2.hand)}
    if current_players.count == 1
      puts "#{current_players[0]} wins the pot of #{total_bet}."
    elsif current_players[-1].hand.value_higher?(current_players[-2].hand) == 0
      puts "It's a draw."
      puts "#{current_players}"
    else
      puts "#{current_players.last} wins the pot of #{total_bet}."
      puts "#{current_players}"
    end
  end


end
