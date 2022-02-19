class ChessPiece
  attr_reader :symbol, :key_name
  
  def initialize
    @symbol = ""
    @key_name = ""
    @move_range = [[]]
    @range_fixed = true
  end

  def movable?(current_pos, new_pos)
    x, y = current_pos
    n_x, n_y = new_pos
    @move_range.each do |move|
      r_x = move[0]
      r_y = move[1]
      if @range_fixed == true
        return true if n_x - x == r_x && n_y - y == r_y
      else
        return true if (n_x - x).to_f/r_x == (n_y - y).to_f/r_y
      end
    end
    false
  end
end
