require_relative '../lib/board.rb'
require_relative '../lib/knight.rb'
require_relative '../lib/bishop.rb'
require_relative '../lib/rook.rb'
require_relative '../lib/queen.rb'
require 'matrix'

class ChessGame
  def initialize()
    @board = Board.new()
    @turn = 'w'
    @message = ''
    play_game()
  end

  def play_game()
    while(true)
      system 'clear'
      puts "        CHESS"
      @board.render_board()
      puts ""

      unless @message == ''
        puts @message 
        @message = ''
      end
      
      puts "#{@turn == 'w' ? "White" : "Black"}'s turn"
      
      valid_move = false
      until valid_move
        print "Type in your move: "
        move = get_move()
        key_name, current_pos, dest_pos = decode_move(move)
        valid_move = move_piece(key_name, current_pos, dest_pos)
      end

      at_base, row, col = pawn_at_base()
      transform_pawn(row, col) if at_base

      @message = "CHECKMATE!" if checkmate?(dest_pos)

      # switch_turn()
    end
  end

  def get_move()
    move_regex = /^[KQBNR]?[a-h][1-8]x?[a-h][1-8][+#]?$/
    loop do
      move = gets.chomp()
      return move if move.match?(move_regex)
      puts "Invalid move, please try again"
      print "Type in your move: "
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
    piece = @board.board[current_y][current_x]

    if correct_piece?(key_name, current_pos)
      if piece.movable?(current_pos, dest_pos)
        return true if move(piece, current_pos, dest_pos)
        return false
      else
        if piece.is_a?(Pawn)
          piece.eat_range.each do |move|
            r_y, r_x = move
            if dest_x - current_x == r_x && dest_y - current_y == r_y
              unless @board.board[dest_y][dest_x].nil?
                move(piece, current_pos, dest_pos)
                return true
              end 
            end
          end
        end
        puts "Invalid move (piece can't move), please try again"
        return false
      end
    else
      puts "No such piece exist at described location, please try again"
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
    piece = @board.board[current_y][current_x]
    dest_piece = @board.board[dest_y][dest_x]

    if pieces_collide?(current_pos, dest_pos)
      puts "Can't move. Allies or Enemies maybe on the way"
      return false
    end

    unless dest_piece.nil?
      if dest_piece.color == @turn
        puts "Can't move, Ally at destination"
        return false
      end
    end

    @board.board[dest_y][dest_x] = piece
    @board.board[current_y][current_x] = nil
    if piece.is_a?(Pawn)
      piece.was_moved unless piece.moved
    end
    return true
  end

  def switch_turn()
    @turn = @turn == 'w' ? 'b' : 'w' 
  end

  def pawn_at_base()
    base = @turn == "w"? @board.board[0] : @board.board[7]
    row = @turn == "w"? 0 : 7
    base.each_with_index do |piece, column|
      unless piece.nil?
        return [true, row, column] if piece.is_a?(Pawn) && piece.color == @turn
      end
    end
    [false, nil, nil]
  end

  def transform_pawn(coor_y, coor_x)
    puts "Class to promote"
    puts "N: Knight"
    puts "B: Bishop"
    puts "R: Rook"
    puts "Q: Queen"
    print "Pawn's promotion requirement has been satisfied! Please type in character of class you want to promote: "
    
    promote_class = ""
    loop do
      promote_class = gets.chomp
      break if promote_class.match?(/[NBRQ]/)
      print "Invalid class, please try again: "
    end

    case promote_class
    when "N" 
      @board.board[coor_y][coor_x] = Knight.new(@turn)
    when "B"  
      @board.board[coor_y][coor_x] = Bishop.new(@turn)
    when "R" 
      @board.board[coor_y][coor_x] = Rook.new(@turn)
    when "Q" 
      @board.board[coor_y][coor_x] = Queen.new(@turn)
    end
  end

  def checkmate?(current_pos)
    current_y, current_x = current_pos
    piece = @board.board[current_y][current_x]

    unless piece.nil?
      if piece.is_a?(Pawn)
        piece.eat_range.each do |move|
          r_y, r_x = move
            dest_y = current_y + r_y
            dest_x = current_x + r_x
            piece_at_dest = @board.board[dest_y][dest_x]
            return true if piece_at_dest.is_a?(King)
        end
      else
        if piece.range_fixed == true
          piece.move_range.each do |move|
            r_y, r_x = move
            dest_y = current_y + r_y
            dest_x = current_x + r_x
            piece_at_dest = @board.board[dest_y][dest_x]
            
            if piece_at_dest.is_a?(King)
              return false if pieces_collide?([current_y, current_x], [dest_y, dest_x])
              return true
            end
          end
        else
          piece.move_range.each do |move|
            r_y, r_x = move
            if r_y == 0
              limit_y = current_y
              limit_x = r_x > 0 ? 8 : -1
              dest_y = current_y
              dest_x = r_x > 0 ? current_x + 1 : current_x - 1

              until dest_y == limit_y && dest_x == limit_x
                dest_piece = @board.board[dest_y][dest_x]
                unless dest_piece.nil?
                  return true if dest_piece.is_a?(King) && dest_piece.color != @turn
                end
                dest_x = r_x > 0 ? dest_x + 1 : dest_x - 1
              end
            elsif r_x == 0
              limit_y = r_y > 0 ? 8 : -1
              limit_x = current_x
              dest_y = r_y > 0 ? current_y + 1 : current_y - 1
              dest_x = current_x

              until dest_y == limit_y && dest_x == limit_x
                dest_piece = @board.board[dest_y][dest_x]
                unless dest_piece.nil?
                  return true if dest_piece.is_a?(King) && dest_piece.color != @turn
                end
                dest_y = r_y > 0 ? dest_y + 1 : dest_y - 1
              end
            else
              limit_y = r_y > 0 ? 8 : -1
              limit_x = r_x > 0 ? 8 : -1
              dest_y = r_y > 0 ? current_y + 1 : current_y - 1
              dest_x = r_x > 0 ? current_x + 1 : current_x - 1

              until dest_y == limit_y || dest_x == limit_x
                dest_piece = @board.board[dest_y][dest_x]
                unless dest_piece.nil?
                  return true if dest_piece.is_a?(King) && dest_piece.color != @turn
                end
                dest_y = r_y > 0 ? dest_y + 1 : dest_y - 1
                dest_x = r_x > 0 ? dest_x + 1 : dest_x - 1
              end
            end
          end
        end
      end
    end

    return false
  end

  def pieces_collide?(org_pos, dest_pos)
    org_y, org_x = org_pos
    dest_y, dest_x = dest_pos
    current_y = dest_y > org_y ? (org_y + 1) : (dest_y < org_y ? org_y - 1 : org_y)
    current_x = dest_x > org_x ? (org_x + 1) : (dest_x < org_x ? org_y - 1 : org_x)

    until current_y == dest_y && current_x == dest_x
      return true unless @board.board[current_y][current_x].nil?

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
    end

    return false
  end

end

game = ChessGame.new()
