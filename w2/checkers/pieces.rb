require_relative 'board'
require_relative 'error'


class Piece
  OFFSETS_UP = [[-1, 1], [-1, -1]]
  OFFSETS_DOWN = [[1, 1], [1, -1]]

  attr_accessor :board, :pos, :king
  attr_reader :color

  def initialize(board, pos, color, king = false)
    @board, @pos, @color, @king = board, pos, color, king
    board[pos] = self
  end

  def inspect
    p pos, color
  end

  def directions
    if king
      OFFSETS_DOWN + OFFSETS_UP
    else
      (color == :black) ? OFFSETS_DOWN : OFFSETS_UP
    end
  end

  def diagonal_moves
    diagonal_moves = []
    directions.each do |offset|
      new_pos = [pos[0] + offset[0], pos[1] + offset[1]]
      diagonal_moves << new_pos if board.on_board?(new_pos)
    end

    diagonal_moves
  end

  def slide_moves
    diagonal_moves.select { |diagonal_move| board[diagonal_move].nil? }
  end

  def adjacent_opponents
    (diagonal_moves - slide_moves).select do |diagonal_move|
      board[diagonal_move].color != color
    end
  end

  def jump_moves
    jump_moves = []
    self.adjacent_opponents.each do |opponent_pos|
      direction = [opponent_pos[0] - pos[0], opponent_pos[1] - pos[1]]
      jump_move = [pos[0] + direction[0] * 2, pos[1] + direction[1] * 2]
      jump_moves << jump_move if board.on_board?(jump_move) && board[jump_move].nil?
    end

    jump_moves
  end

  def moves
    slide_moves + jump_moves
  end

  def perform_slide(end_pos)
    return false unless slide_moves.include?(end_pos)

    board[end_pos] = self
    board[self.pos] = nil
    self.pos = end_pos
    promote if can_promote?
    return "slide"
  end

  def perform_jump(end_pos)
    return false unless jump_moves.include?(end_pos)

    board[end_pos] = self
    board[self.pos] = nil
    board[[pos[0] + (end_pos[0] - pos[0]) / 2, pos[1] + (end_pos[1] - pos[1]) / 2]] = nil
    self.pos = end_pos
    promote if can_promote?
    return "jump"
  end

  def can_promote?
    opposite_row = (color == :white ) ? 0 : 7
    self.pos[0] == opposite_row
  end

  def promote
    self.king = true
  end

  def perform_moves!(*move_sequence)
    begin
      if move_sequence.size == 1
        perform_slide(move_sequence[0]) or perform_jump(move_sequence[0]) or raise InvalidMoveError.new
      else
        move_sequence.each_cons(2) do |move1, move2|
          perform_jump(move1) or raise InvalidMoveError.new
          board[move1].perform_jump(move2) or raise InvalidMoveError.new
        end
      end
    rescue InvalidMoveError => e
      return false
    end
  end

  def valid_move_seq?(*move_sequence)
    new_board = board.dup
    new_board[pos].perform_moves!(*move_sequence)
  end

  def perform_moves(*move_sequence)
    if valid_move_seq?(*move_sequence)
      perform_moves!(*move_sequence)
    else
      raise InvalidMoveError.new "Can't move there!"
    end
  end


end
