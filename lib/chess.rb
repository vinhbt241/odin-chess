require_relative '../lib/board.rb'

class ChessGame
  def initialize()
    @board = Board.new()
    @turn = 'w'

    play_game()
  end

  def play_game()
    while(true)
      system 'clear'
      puts "        CHESS"
      @board.render_board()
      puts ""
      puts "#{@turn == 'w' ? "White" : "Black"}'s turn"
      valid_move = false
      until valid_move
        print "Type in your move: "
        move = get_move()
        key_name, current_pos, dest_pos = decode_move(move)
        valid_move = move_piece(key_name, current_pos, dest_pos)
      end
      switch_turn()
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
        return true if move(piece, current_pos, dest_pos)
        return false
      else
        if piece.is_a?(Pawn)
          eat_range = piece.color == "w" ? [[-1, -1], [-1, 1]] : [[1, -1], [1, 1]]
          eat_range.each do |move|
            r_y, r_x = move
            if dest_x - current_x == r_x && dest_y - current_y == r_y
              return true if move(piece, current_pos, dest_pos)
            end
          end
          puts "Invalid move (piece can't move), please try again"
          return false
        else
          puts "Invalid move (piece can't move), please try again"
          return false
        end
      end
    else
      puts "Invalid chess piece, please try again"
      return false
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

  def move(piece, current_pos, dest_pos)    
    current_y, current_x = current_pos
    dest_y, dest_x = dest_pos
    original_y = current_y
    original_x = current_x

    loop do 
      old_y = current_y
      old_x = current_x

      if dest_y > current_y
        current_y += 1
      elsif dest_y < current_y
        current_y -= 1
      end
      if dest_x > current_x
        current_x += 1
      elsif dest_x < current_x
        current_x -= 1
      end

      unless @board.board[current_y][current_x].nil?
        if current_y == dest_y && current_x == dest_x
          dest_piece = @board.board[current_y][current_x]
          if dest_piece.color == @turn
            puts "Can't move, Ally at destination"
            return false
          else
            @board.board[current_y][current_x] = piece
            @board.board[original_y][original_x] = nil
            piece.was_moved if piece.is_a?(Pawn)
            return true
          end
        else
          puts "Can't move. Allies or Enemies maybe on the way"
          return false
        end
      end

      if current_y == dest_y && current_x == dest_x
        @board.board[current_y][current_x] = piece
        @board.board[original_y][original_x] = nil
        piece.was_moved if piece.is_a?(Pawn)
        return true
      end
    end
  end

  def switch_turn()
    @turn = @turn == 'w' ? 'b' : 'w' 
  end

end

game = ChessGame.new()
