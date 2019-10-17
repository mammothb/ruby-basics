require_relative "board.rb"
require_relative "chess_piece_helper.rb"
require_relative "movement.rb"

class ChessPiece
  attr_reader :color, :symbol
  attr_accessor :pos

  def initialize(symbol, color, pos)
    @symbol = symbol[color]
    @color = color
    @pos = pos
  end

  def impossible_move?(from, to, capture)
    if distance == 1
      !directions.include?(distance_vector(from, to))
    elsif from != to
      # Convert to absolute for easier calculations and since
      # directions for Unlimited movements are mirrored
      direction = distance_vector(from, to).map(&:abs)
      min_mag = direction.select{ |x| x != 0 }.min
      !directions.include?(direction.map { |x| (x.to_f / min_mag).ceil })
    else
      true
    end
  end

  def obstructed?(board, from, to)
    if distance > 1
      direction = distance_vector(from, to)
      steps = direction.map(&:abs).max
      direction.map! { |x| x / steps }
      (1...steps).map do |n|
        from.zip(direction).map { |x, d| x + d * n }
      end.any? { |pos| board[pos].is_a?(ChessPiece) }
    else
      false
    end
  end
end

class King < ChessPiece
  include Movement::SingleStep
  include Movement::OmniDirectional

  def initialize(color, pos = nil)
    super({ white: "\u2654", black: "\u265A" }, color, pos)
  end
end

class Queen < ChessPiece
  include Movement::Unlimited
  include Movement::OmniDirectional

  def initialize(color, pos = nil)
    super({ white: "\u2655", black: "\u265B" }, color, pos)
  end
end

class Rook < ChessPiece
  include Movement::Unlimited
  include Movement::Straight

  def initialize(color, pos = nil)
    super({ white: "\u2656", black: "\u265C" }, color, pos)
  end
end

class Bishop < ChessPiece
  include Movement::Unlimited
  include Movement::Diagonal

  def initialize(color, pos = nil)
    super({ white: "\u2657", black: "\u265D" }, color, pos)
  end
end

class Knight < ChessPiece
  include Movement::SingleStep

  def initialize(color, pos = nil)
    super({ white: "\u2658", black: "\u265E" }, color, pos)
  end

  def directions
    [[2, -1], [2, 1], [-2, -1], [-2, 1], [-1, 2], [1, 2], [-1, -2], [1, -2]]
  end
end

class Pawn < ChessPiece
  include Movement::SingleStep

  def initialize(color, pos = nil)
    super({ white: "\u2659", black: "\u265F" }, color, pos)
    @baseline = @color == "white" ? 1 : 6
    @is_on_baseline = true
    @is_capturing = false
  end

  def directions
    arr = [[1, 0]]
    arr += [[2, 0]] if @is_on_baseline
    arr += [[1, 1], [1, -1]] if @is_capturing
    @color == "white" ? arr : arr.map { |x| x.map { |i| -i } }
  end

  def impossible_move?(from, to, capture)
    @is_on_baseline = from[0] == @baseline
    @is_capturing = capture
    super
  end

  def obstructed?(board, from, to)
    if @is_on_baseline
      nrow = distance_vector(from, to)[0]
      steps = nrow.abs
      if steps == 2
        return board[from[0] + nrow / steps][from[1]].is_a?(ChessPiece)
      end
    end
    false
  end
end
