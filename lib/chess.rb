require_relative '../lib/board.rb'

class ChessGame
  def initialize()
    @board = Board.new()
    @turn = 'White'

    play_game()
  end

  def play_game()
    @board.render_board()
    puts ""
    puts "#{@turn}'s turn"
    print "Type in your move: "
    move = get_move()
  end

  def get_move()
    move_regex = /^[KQBNR]?[1-8]?[a-h]?x?[a-h][1-8][+#]?$/
    loop do
      move = gets.chomp()
      break if move.match?(move_regex)
      puts "Invalid move, please try again"
    end 
  end

  def decode_move(move)
    
  end
end

game = ChessGame.new()
