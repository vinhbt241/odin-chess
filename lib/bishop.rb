require 'colorize'

require_relative '../lib/chess_piece.rb'

class Bishop < ChessPiece
  def initialize(color = "w")
    @color = color
    @symbol = color == "w" ? "♗".black : "♝".black
    @key_name = "B"
    @move_range = [[7, 7], [7, -7], [-7, 7], [-7, -7]]
    @range_fixed = false
  end
end
