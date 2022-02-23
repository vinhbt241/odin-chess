require 'colorize'

require_relative '../lib/pawn.rb'
require_relative '../lib/knight.rb'
require_relative '../lib/bishop.rb'
require_relative '../lib/rook.rb'
require_relative '../lib/king.rb'
require_relative '../lib/queen.rb'

class Board
  attr_accessor :board

  def initialize()
    @board = init_board()
  end

  def init_board()
    board = Array.new(8) { Array.new(8) }
    board = set_pieces(board)
    board
  end

  def render_board()
    board = @board.each_with_index.map do |row, index|
      if index.even? 
        row = row.each_with_index.map do |pos, i|
          if i.even?
            pos = pos.nil? ? "  ".on_white : " #{pos.symbol}".on_white
          else
            pos = pos.nil? ? "  ".on_magenta : " #{pos.symbol}".on_magenta
          end
          pos
        end
      else
        row = row.each_with_index.map do |pos, i|
          if i.odd?
            pos = pos.nil?  ? "  ".on_white : " #{pos.symbol}".on_white
          else
            pos = pos.nil?  ? "  ".on_magenta : " #{pos.symbol}".on_magenta
          end
          pos
        end
      end
    end

    coor_alphabet = []
    "a".upto("h") { |c| coor_alphabet << c }

    render_alphabet = "   #{coor_alphabet.join(" ")}\n"
    render_board = render_alphabet
    board.each_with_index do |row, index|
      render_board += "#{8 - index} #{row.join("")} #{8 - index}\n"
    end
    render_board += render_alphabet

    puts render_board
  end

  def set_pieces(board)
    board[0] = board[0].each_with_index.map do |piece, index|
      case index
      # when 0, 7
      #   piece = Rook.new('b')
      # when 1, 6
      #   piece = Knight.new('b')
      # when 2, 5
      #   piece = Bishop.new('b')
      when 3 
        piece = King.new('b')
      # when 4
      #   piece = Queen.new('b')
      # else
      #   print "Invalid index"
      end
    end
    board[7] = board[7].each_with_index.map do |piece, index|
      case index
      when 0, 7
        piece = Rook.new('w')
      when 1, 6
        piece = Knight.new('w')
      when 2, 5
        piece = Bishop.new('w')
      when 3 
        piece = King.new('w')
      when 4
        piece = Queen.new('w')
      else
        print "Invalid index"
      end
    end
    board[1].map! { |piece| piece = Pawn.new('b')  }  
    # board[6].map! { |piece| piece = Pawn.new('w')  } 
    board
  end
end



