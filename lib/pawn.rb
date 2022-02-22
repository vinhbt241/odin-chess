require 'colorize'

require_relative '../lib/chess_piece.rb'

class Pawn < ChessPiece
  def initialize(color = "w")
    @color = color
    @key_name = "P"
    @symbol = @color == "w" ? "♙".black : "♟︎".black
    @range_fixed = false
    @move_range = @color == "w" ? [[-2, 0]] : [[2, 0]]
  end

  def was_moved()
    @range_fixed = true
    @move_range = @color == "w" ? [[-1, 0]] : [[1, 0]]
  end
end

