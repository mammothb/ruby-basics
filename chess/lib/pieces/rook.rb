require_relative "movement.rb"
require_relative "piece.rb"

class Rook < Piece
  include Movement::MultiStep
  include Movement::Straight

  def initialize(color, pos = nil)
    super({ w: "\u2656", b: "\u265C" }, color, pos)
  end
end