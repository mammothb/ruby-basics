require_relative "movement.rb"
require_relative "piece.rb"

class Pawn < Piece
  include Movement::SingleStep

  def initialize(color, pos = nil)
    super({ w: "\u2659", b: "\u265F" }, color, pos)
    @baseline = @color == :w ? 1 : 6
    @is_on_baseline = true
    @is_capturing = false
  end

  def directions
    arr = [[1, 0]]
    arr += [[2, 0]] if @is_on_baseline
    arr += [[1, 1], [1, -1]] if @is_capturing
    @color == :w ? arr : arr.map { |x| x.map { |i| -i } }
  end

  def impossible_move?(to, capture)
    @is_on_baseline = row == @baseline
    @is_capturing = capture
    super
  end

  def obstructed?(values, to)
    if @is_on_baseline
      case distance_vector(pos, to)[0]
      when 2
        return values[row + 1][col].is_a?(Piece)
      when -2
        return values[row - 1][col].is_a?(Piece)
      end
    end
    false
  end
end
