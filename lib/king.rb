require 'colorize'

require_relative '../lib/chess_piece.rb'

class King < ChessPiece
  def initialize(color = "w")
    @color = color
    @symbol = color == "w" ? "♔".black : "♚".black
    @key_name = "K"
    @move_range = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @range_fixed = true
  end
end
