# frozen_string_literal: true

require_relative 'movement.rb'
require_relative 'piece.rb'

class Bishop < Piece
  include Movement::MultiStep
  include Movement::Diagonal

  def initialize(color, pos = nil)
    super({ w: "\u2657", b: "\u265D" }, color, pos)
  end
end
