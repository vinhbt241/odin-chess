class ChessPiece
  def initialize
    @symbol = ""
    @key_name = ""
    @move_range = [[]]
  end

  def movable?(current_pos, new_pos)
    x, y = current_pos
    n_x, n_y = new_pos
    @move_range.each do |move|
      r_x = move[0]
      r_y = move[1]
      return true if n_x - x == r_x && n_y - y == r_y
    end
    false
  end
end
