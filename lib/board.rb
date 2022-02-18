require 'colorize'

class Board
  def initialize()
    @board = init_board()
  end

  def init_board()
    board = Array.new(8) { Array.new(8, "  ") }
  end

  def render_board()
    board = @board.each_with_index.map do |row, index|
      if index.even? 
        row = row.each_with_index.map do |pos, i|
          if i.even?
            pos = pos.on_white
          else
            pos = pos.on_magenta
          end
          pos
        end
      else
        row = row.each_with_index.map do |pos, i|
          if i.odd?
            pos = pos.on_white
          else
            pos = pos.on_magenta
          end
          pos
        end
      end
    end

    render_board = ""
    board.each do |row|
      render_board += row.join("")
      render_board += "\n"
    end

    puts render_board
  end

  def add_piece(piece, coor_x, coor_y)
    @board[coor_x][coor_y] = " #{piece}"
  end
end

# board = Board.new()

# board.render_board()
# board.add_piece("♔".black, 0, 0)
# board.add_piece("♕".black, 0, 1)
# board.add_piece("♜".black, 2, 3)
# board.add_piece("♞".black, 2, 4)
# puts " "
# board.render_board()

