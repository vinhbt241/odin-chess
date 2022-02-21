require_relative '../lib/board.rb'

class ChessGame
  def initialize()
    @board = Board.new()
    @turn = 'w'

    play_game()
  end

  def play_game()
    while(true)
      @board.render_board()
      puts ""
      puts "#{@turn == 'w' ? "White" : "Black"}'s turn"
      print "Type in your move: "
      move = get_move()
      key_name, current_pos, dest_pos = decode_move(move)
      move_piece(key_name, current_pos, dest_pos)
    end
  end

  def get_move()
    move_regex = /^[KQBNR]?[a-h][1-8]x?[a-h][1-8][+#]?$/
    loop do
      move = gets.chomp()
      return move if move.match?(move_regex)
      puts "Invalid move, please try again"
    end 
  end

  def decode_move(move)
    key_name = move[0].match?(/[KQBNR]/) ? move[0] : "P"
    current_y_num = move[2].match?(/[1-8]/) ? move[2] : move[1]
    current_x_char = move[1].match?(/[a-h]/) ? move[1] : move[0]
    dest_y_num = move[-1].match?(/[1-8]/) ? move[-1] : move[-2]
    dest_x_char = move[-2].match?(/[a-h]/) ? move[-2] : move[-3]
    
    current_y = 8 - current_y_num.to_i
    current_x = case current_x_char
    when "a" then 0
    when "b" then 1
    when "c" then 2
    when "d" then 3
    when "e" then 4
    when "f" then 5
    when "g" then 6
    when "h" then 7
    end
    dest_y = 8 - dest_y_num.to_i
    dest_x = case dest_x_char
    when "a" then 0
    when "b" then 1
    when "c" then 2
    when "d" then 3
    when "e" then 4
    when "f" then 5
    when "g" then 6
    when "h" then 7
    end

    [key_name, [current_y, current_x], [dest_y, dest_x]]
  end

  def move_piece(key_name, current_pos, dest_pos)
    current_y, current_x = current_pos
    dest_y, dest_x = dest_pos

    if correct_piece?(key_name, current_pos)
      piece = @board.board[current_y][current_x]

      if piece.movable?(current_pos, dest_pos)
        @board.board[dest_y][dest_x] = piece
        @board.board[current_y][current_x] = nil
      else
        puts "Invalid move (piece can't move), please try again"
      end
    else
      puts "Invalid chess piece, please try again"
    end
  end

  def correct_piece?(key_name, current_pos)
    current_y, current_x = current_pos
    piece = @board.board[current_y][current_x]

    unless piece.nil?
      return true if piece.key_name == key_name && piece.color == @turn
    end

    false
  end
end

game = ChessGame.new()
