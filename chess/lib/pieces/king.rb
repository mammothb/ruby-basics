require_relative "movement.rb"
require_relative "piece.rb"

class King < Piece
  include Movement::SingleStep
  include Movement::OmniDirectional

  def initialize(color, pos = nil)
    super({ w: "\u2654", b: "\u265A" }, color, pos)
  end
end
