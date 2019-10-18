require_relative "movement.rb"
require_relative "piece.rb"

class Queen < Piece
  include Movement::MultiStep
  include Movement::OmniDirectional

  def initialize(color, pos = nil)
    super({ w: "\u2655", b: "\u265B" }, color, pos)
  end
end
