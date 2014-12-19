# encoding: utf-8
require_relative 'pieces'
require_relative 'game'
require_relative 'error'
require 'colorize'


class Board
  attr_accessor :grid
  attr_reader

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }
    return unless setup
    odd_setup
    even_setup
  end

  def on_board?(pos)
    pos.all? { |i| i.between?(0, 7)}
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def dup
    new_board = self.class.new(false)
    grid.each do |row|
      row.each do |piece|
        piece.class.new(new_board, piece.pos, piece.color, piece.king) unless piece.nil?
      end
    end

    new_board
  end

  def won?
    # if none of a player's piece left
    colors_left = pieces.map { |piece| piece.color }.uniq
    return colors_left[0] if colors_left.size == 1
    # or none of a player's piece can move since blocked
    white_pieces = pieces.select { |piece| piece.color == :white }
    black_pieces = pieces - white_pieces
    return :white if black_pieces.all? { |piece| piece.moves.empty? }
    return :black if white_pieces.all? { |piece| piece.moves.empty? }
    return false
  end

  def pieces
    grid.flatten.compact
  end

  def inspect
    "0---1-----2-----3-----4-----5-----6-----7\n " +
    grid.map do |row|
      (row.map do |pos|
        if pos.nil?
          " * "
        elsif pos.color == :white
          " w "
        else
          " b "
        end
      end).join(" | ")
    end.join(" \n ")

  end

  def render(cursor_position = [0,0], message = "")
    system('clear')
    grid_display = grid.map.with_index do |row, row_i|
      row.map.with_index do |pos, col_i|
        if pos.nil?
          "   "
        elsif pos.color == :white
          if pos.king
            " ◎ "
          else
            " ○ "
          end
        else
          if pos.king
            " ◉ "
          else
            " ● "
          end
        end
      end
    end

    # current cursor should be different color
    grid_display.map!.with_index do |row, row_i|
      row.map.with_index do |pos, col_i|
        if cursor_position == [row_i, col_i]
          if pos == "   "
            " * ".cyan
          else
            pos.cyan
          end
        else
          pos
        end
      end.join("|")
    end

    puts
    puts "     0   1   2   3   4   5   6   7\n" +
    "   ╔═══════════════════════════════╗\n" +
    grid_display.map.with_index { |row, i| " #{i} ║#{row}║" }.join("\n") +
    "\n   ╚═══════════════════════════════╝"
    puts message

  end






  private
  def even_setup
    for row in [0, 2, 6]
      for col in [1, 3, 5, 7]
        color = (row == 6) ? :white : :black
        Piece.new(self, [row, col], color)
      end
    end
  end


  def odd_setup
    for row in [1, 5, 7]
      for col in [0, 2, 4, 6]
        color = (row == 1) ? :black : :white
        Piece.new(self,[row, col], color)
      end
    end
  end




end
