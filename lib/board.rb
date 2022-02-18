require 'colorize'

class Board
  BLACK_SQUARE = "■"
  WHITE_SQUARE = "□"

  attr_reader :board

  def initialize()
    @board = init_board()
  end

  def init_board()
    board = Array.new(8) { Array.new(8) }

    board = board.each_with_index.map do |row, index|
      if index.even? 
        row = row.each_with_index.map do |pos, i|
          if i.even?
            pos = " ♔".black.on_white
          else
            pos = "  ".on_red
          end
          pos
        end
      else
        row = row.each_with_index.map do |pos, i|
          if i.odd?
            pos = "  ".on_white
          else
            pos = "  ".on_red
          end
          pos
        end
      end
    end
  end

end

board = Board.new()
board.board.each do |row|
  row.each { |pos| print pos }
  print "\n"
end

