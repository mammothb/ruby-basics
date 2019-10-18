require_relative "movement.rb"
require_relative "piece.rb"

class Knight < Piece
  include Movement::SingleStep

  def initialize(color, pos = nil)
    super({ w: "\u2658", b: "\u265E" }, color, pos)
  end

  def directions
    [[2, -1], [2, 1], [-2, -1], [-2, 1], [-1, 2], [1, 2], [-1, -2], [1, -2]]
  end
end
