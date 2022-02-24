require 'colorize'

require_relative '../lib/chess_piece.rb'

class Pawn < ChessPiece
  attr_reader :eat_range, :moved

  def initialize(color = "w")
    @color = color
    @key_name = "P"
    @symbol = @color == "w" ? "♙".black : "♟︎".black
    @range_fixed = false
    @moved = false
    @move_range = @color == "w" ? [[-2, 0]] : [[2, 0]]
    @eat_range = @color == "w" ? [[-1, -1], [-1, 1]] : [[1, -1], [1, 1]]
  end

  def was_moved()
    @moved = true
    @range_fixed = true
    @move_range = @color == "w" ? [[-1, 0]] : [[1, 0]]
  end
end

