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
            pos = "   ".black.on_white
          else
            pos = "   ".black.on_magenta
          end
          pos
        end
      else
        row = row.each_with_index.map do |pos, i|
          if i.odd?
            pos = "   ".black.on_white
          else
            pos = "   ".black.on_magenta
          end
          pos
        end
      end
    end
  end

  def render_board()
    board = ""
    @board.each do |row|
      board += row.join("")
      board += "\n"
    end
    puts board
  end

end

board = Board.new()

board.render_board()

