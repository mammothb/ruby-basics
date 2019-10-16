require_relative "board.rb"
require_relative "movement.rb"

class ChessPiece
  attr_reader :color, :symbol

  def initialize(symbol, color)
    @symbol = color == "white" ? symbol[0] : symbol[1]
    @color = color
  end

  def impossible_move?(from, to, capture)
    if distance == 1
      directions.include?([to, from].transpose.map { |x| x.reduce(:-) })
    elsif from != to
      # Convert to absolute for easier calculations and since
      # directions for Unlimited movements are mirrored
      direction = [to, from].transpose.map { |x| x.reduce(:-) }.map(&:abs)
      min_mag = direction.select{ |x| x != 0 }.min
      directions.include?(direction.map { |x| (x.to_f / min_mag).ceil })
    else
      false
    end
  end

  def obstructed?(from, to)
    false
  end
end

class King < ChessPiece
  include Movement::SingleStep
  include Movement::OmniDirectional

  def initialize(color)
    super(["\u2654", "\u265A"], color)
  end
end

class Queen < ChessPiece
  include Movement::Unlimited
  include Movement::OmniDirectional

  def initialize(color)
    super(["\u2655", "\u265B"], color)
  end
end

class Rook < ChessPiece
  include Movement::Unlimited
  include Movement::Straight

  def initialize(color)
    super(["\u2656", "\u265C"], color)
  end
end

class Bishop < ChessPiece
  include Movement::Unlimited
  include Movement::Diagonal

  def initialize(color)
    super(["\u2657", "\u265D"], color)
  end
end

class Knight < ChessPiece
  include Movement::SingleStep

  def initialize(color)
    super(["\u2658", "\u265E"], color)
  end

  def directions
    [[2, -1], [2, 1], [-2, -1], [-2, 1], [-1, 2], [1, 2], [-1, -2], [1, -2]]
  end
end

class Pawn < ChessPiece
  include Movement::SingleStep

  def initialize(color)
    super(["\u2659", "\u265F"], color)
    @baseline = color == "white" ? 1 : 6
  end

  def directions
    [[0, 1]]
  end

  # def impossible_move?(from, to, capture)
  # end
end

if __FILE__ == $0
  a = [[1, 2], [1, 2]]
  p a
  dif = a.transpose.map { |x| x.reduce(:-) }.map(&:abs)
  min_mag = dif.select { |x| x != 0}.min
  p dif
  dif.map! { |x| (x.to_f / min_mag).ceil rescue 0 }
  p dif
  p min_mag
end