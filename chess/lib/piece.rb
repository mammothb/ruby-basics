require_relative "board.rb"
require_relative "piece_helper.rb"
require_relative "movement.rb"

class Piece
  attr_reader :color, :symbol
  attr_accessor :pos

  def initialize(symbol, color, pos)
    @symbol = symbol[color]
    @color = color
    @pos = pos
  end

  def impossible_move?(to, capture)
    if distance == 1
      !directions.include?(distance_vector(pos, to))
    elsif pos != to
      # Convert to absolute for easier calculations and since
      # directions for MultiStep movements are mirrored
      direction = distance_vector(pos, to).map(&:abs)
      min_mag = direction.select{ |x| x != 0 }.min
      !directions.include?(direction.map { |x| (x.to_f / min_mag).ceil })
    else
      true
    end
  end

  def obstructed?(board, to)
    if distance > 1
      direction = distance_vector(pos, to)
      steps = direction.map(&:abs).max
      direction.map! { |x| x / steps }
      (1...steps).map do |n|
        pos.zip(direction).map { |x, d| x + d * n }
      end.any? { |coord| board[coord].is_a?(Piece) }
    else
      false
    end
  end
end

class King < Piece
  include Movement::SingleStep
  include Movement::OmniDirectional

  def initialize(color, pos = nil)
    super({ w: "\u2654", b: "\u265A" }, color, pos)
  end
end

class Queen < Piece
  include Movement::MultiStep
  include Movement::OmniDirectional

  def initialize(color, pos = nil)
    super({ w: "\u2655", b: "\u265B" }, color, pos)
  end
end

class Rook < Piece
  include Movement::MultiStep
  include Movement::Straight

  def initialize(color, pos = nil)
    super({ w: "\u2656", b: "\u265C" }, color, pos)
  end
end

class Bishop < Piece
  include Movement::MultiStep
  include Movement::Diagonal

  def initialize(color, pos = nil)
    super({ w: "\u2657", b: "\u265D" }, color, pos)
  end
end

class Knight < Piece
  include Movement::SingleStep

  def initialize(color, pos = nil)
    super({ w: "\u2658", b: "\u265E" }, color, pos)
  end

  def directions
    [[2, -1], [2, 1], [-2, -1], [-2, 1], [-1, 2], [1, 2], [-1, -2], [1, -2]]
  end
end

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
    @is_on_baseline = pos[0] == @baseline
    @is_capturing = capture
    super
  end

  def obstructed?(board, to)
    if @is_on_baseline
      nrow = distance_vector(pos, to)[0]
      steps = nrow.abs
      if steps == 2
        return board[pos[0] + nrow / steps][pos[1]].is_a?(Piece)
      end
    end
    false
  end
end
