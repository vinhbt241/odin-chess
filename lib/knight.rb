require 'colorize'

require_relative '../lib/chess_piece.rb'

class Knight < ChessPiece
  attr_reader :symbol

  def initialize(color = "w")
    @symbol = color == "w" ? "♘".black : "♞".black
    @key_name = "N"
    @move_range = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]
    @range_fixed = true
  end
end

