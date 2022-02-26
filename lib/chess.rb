require_relative '../lib/board.rb'
require_relative '../lib/knight.rb'
require_relative '../lib/bishop.rb'
require_relative '../lib/rook.rb'
require_relative '../lib/queen.rb'
require 'matrix'
require 'yaml'

class ChessGame
  def initialize()
    @board = Board.new()
    @turn = 'w'
    @message = ''
    @victory = false
  end

  def play_game()
    loop do
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

        case move
        when "S"
          system 'clear'
          display_save_files()
          puts ""
          print "Name your save file: "
          file_name = gets.chomp
          save_game(file_name)

          system 'clear'
          display_save_files()
          print "Type C to return to the game, or R to exit: "
          loop do
            continue = gets.chomp

            if continue == "R"
              system 'clear'
              puts "Game closed"
              return
            end

            if continue == "C"
              system 'clear'
              puts "        CHESS"
              @board.render_board()
              puts ""
              break
            end
            print "Invalid command, please try again: "
          end
        when "R"
          system 'clear'
          puts "Game closed"
          return
        when "L"
          system 'clear'
          display_save_files()
          puts ""
          print "Type in name of save file you want to load from: "
          loop do 
            file_name = gets.chomp

            if File.exist?("save_files/#{file_name}.yaml")
              load_game(file_name)
              puts "Loading Complete"
              break
            end
            print "Save file does not exist, please try again: "
          end
          
          print "Type C to continue the game: "
          loop do
            continue = gets.chomp
            if continue == "C"
              system 'clear'
              puts "        CHESS"
              @board.render_board()
              puts ""
              break
            end
            print "Invalid command, please try again: "
          end
        else
          key_name, current_pos, dest_pos = decode_move(move)
          valid_move = move_piece(key_name, current_pos, dest_pos)
        end
      end

      if @victory
        system 'clear'
        puts "        CHESS"
        @board.render_board()
        puts ""

        puts "#{@turn == 'w' ? "White" : "Black"} won!"
        break
      end

      at_base, row, col = pawn_at_base()
      transform_pawn(row, col) if at_base

      @message = "CHECKMATE!" if checkmate?(dest_pos)

      switch_turn()
    end
  end

  def get_move()
    move_regex = /^[KQBNR]?[a-h][1-8]x?[a-h][1-8][+#]?$|^S$|^R$|^L$/

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
      elsif dest_piece.is_a?(King) && dest_piece.color != @turn
        @board.board[dest_y][dest_x] = piece
        @board.board[current_y][current_x] = nil
        if piece.is_a?(Pawn)
          piece.was_moved unless piece.moved
        end
        @victory = true
        return true
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
                  if dest_piece.is_a?(King) && dest_piece.color != @turn
                    return true unless pieces_collide?(current_pos, [dest_y, dest_x])
                  end
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
                  if dest_piece.is_a?(King) && dest_piece.color != @turn
                    return true unless pieces_collide?(current_pos, [dest_y, dest_x])
                  end
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
                  if dest_piece.is_a?(King) && dest_piece.color != @turn
                    return true unless pieces_collide?(current_pos, [dest_y, dest_x])
                  end
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
    current_x = dest_x > org_x ? (org_x + 1) : (dest_x < org_x ? org_x - 1 : org_x)

    if current_y == org_y || current_x == org_x
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
    else
      until current_y == dest_y || current_x == dest_x
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
    end

    return false
  end

  def to_yaml()
    YAML.dump ({
      :board => @board,
      :turn => @turn,
      :message => @message,
      :victory => @victory
    })
  end

  def save_game(file_name)
    dir_name = 'save_files'
    Dir.mkdir(dir_name) unless File.exist?(dir_name)

    save_file = "save_files/#{file_name}.yaml"

    if File.exist?(save_file)
      print "Save file #{file_name} already exist, do you want to override the content of this save file ? (Y/N): "
      loop do
        confirm_override = gets.chomp
        break if confirm_override == "Y"
        return if confirm_override == "N"
        print "Invalid character, please try again: "
      end
    end

    save_content = to_yaml()
    File.open(save_file, 'w') { |f| f.write(save_content) }
  end

  def display_save_files()
    dir_name = 'save_files'
    Dir.mkdir(dir_name) unless File.exist?(dir_name)

    save_files = Dir.glob("#{dir_name}/*")
    save_files.each_with_index do |save_file, index|
      puts "#{index + 1}. #{File.basename(save_file).split(".")[0]}"
    end

  end

  def load_game(file_name)
    dir_name = 'save_files'
    Dir.mkdir(dir_name) unless File.exist?(dir_name)
    save_path = "#{dir_name}/#{file_name}.yaml"

    if File.exist?(save_path)
      save_file = File.read(save_path)
      save_content = YAML.load(save_file)

      @board = save_content[:board]
      @turn = save_content[:turn]
      @message = save_content[:message]
      @victory = save_content[:victory]
    else
      puts "Save file doest not exist"
    end
  end

end
