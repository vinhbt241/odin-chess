require 'colorize'

require_relative '../lib/chess_piece.rb'

class Bishop < ChessPiece
  attr_reader :symbol

  def initialize(color = "w")
    @symbol = color == "w" ? "♗".black : "♝".black
    @key_name = "B"
    @move_range = [[7, 7], [7, -7], [-7, 7], [-7, -7]]
    @range_fixed = false
  end
end
