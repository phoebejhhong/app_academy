require_relative 'pieces'
require_relative 'board'
require 'io/console'


class Game
  attr_accessor
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def run
    until board.won?
        turn(:black)
        break if board.won?
        turn(:white)
    end
    puts "#{board.won?.upcase} WINS!"
  end

  def turn(color, message = nil)
    begin
      message ||= "#{color.to_s.capitalize}'s turn. \nWhich piece?"
      board.render([0,0], message)
      start_pos = kb_user_input
      unless board[start_pos]
        raise InvalidMoveError.new "Nothing's there!"
      end
      unless board[start_pos].color == color
        raise InvalidMoveError.new "Wrong color!"
      end
      end_pos = kb_user_input(start_pos.dup, "Where to?")
      move_type = board[start_pos].perform_moves(end_pos)
      if move_type == "jump" && !board[end_pos].jump_moves.empty?
        turn(color, "Jump Again, #{color}! \nWhich piece?")
      end
    rescue InvalidMoveError => e
      board.render([0,0], "#{e.message} Press any key to retry")
      retry if STDIN.getch
    end
  end


  def kb_user_input(current_pos = [0,0], message="")
    input = STDIN.getch

    unless input == "\r"
      system('clear')
      case input
      when 'w'
        current_pos[0] -= 1 if current_pos[0].between?(1,7)
      when 'a'
        current_pos[1] -= 1 if current_pos[1].between?(1,7)
      when 's'
        current_pos[0] += 1 if current_pos[0].between?(0,6)
      when 'd'
        current_pos[1] += 1 if current_pos[1].between?(0,6)
      when 'q'
        exit
      end
      # Print board with new cursor position
      board.render(current_pos, message)
      kb_user_input(current_pos)
    end

    current_pos
  end


end
