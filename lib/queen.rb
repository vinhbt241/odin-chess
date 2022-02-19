require 'colorize'

require_relative '../lib/chess_piece.rb'

class Queen < ChessPiece
  def initialize(color = "w")
    @symbol = color == "w" ? "♕".black : "♛".black
    @key_name = "Q"
    @move_range = [[7, 0], [-7, 0], [0, 7], [0, -7], [7, 7], [7, -7], [-7, 7], [-7, -7]]
    @range_fixed = false
  end
end
