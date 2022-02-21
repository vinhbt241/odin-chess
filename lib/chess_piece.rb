require 'matrix'

class ChessPiece
  attr_reader :symbol, :key_name, :color
  
  def initialize()
    @@symbol = ""
    @@key_name = ""
    @@move_range = [[]]
    @@range_fixed = true
  end

  def movable?(current_pos, new_pos)
    y, x = current_pos
    n_y, n_x = new_pos
    @move_range.each do |move|
      r_y, r_x = move
      if @range_fixed == true
        return true if n_x - x == r_x && n_y - y == r_y
      else
        vector_pos = Vector[n_y - y, n_x - x]
        vector_r = Vector[r_y, r_x]
        return true unless Vector.independent?(vector_pos, vector_r)
      end
    end
    false
  end
end
