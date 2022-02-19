require_relative '../lib/chess_piece.rb'

class Pawn < ChessPiece
  attr_reader :symbol

  def initialize(color = "w")
    @symbol = color == "w" ? "♙" : "♟︎"
    @move_range = color == "w" ? [[0, 1]] : [[0, -1]]
  end
end

# pawn = Pawn.new()
# puts pawn.movable?([0, 0],[0, 1])
# puts pawn.symbol
