require 'colorize'

require_relative '../lib/chess_piece.rb'

class Pawn < ChessPiece
  def initialize(color = "w")
    @symbol = color == "w" ? "♙".black : "♟︎".black
    @move_range = color == "w" ? [[0, 1]] : [[0, -1]]
  end
end

