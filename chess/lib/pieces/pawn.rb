# frozen_string_literal: true

require_relative 'movement.rb'
require_relative 'piece.rb'

class Pawn < Piece
  include Movement::SingleStep

  attr_writer :two_square_opening

  def initialize(color, pos = nil)
    super({ w: "\u2659", b: "\u265F" }, color, pos)
    @baseline = @color == :w ? 1 : 6
    @last_rank = @color == :w ? 7 : 0
    @is_on_baseline = true
    @is_capturing = false
    @two_square_opening = false
    @en_passant = false
  end

  def directions
    if @is_capturing
      arr = [[1, 1], [1, -1]]
    else
      arr = [[1, 0]]
      arr += [[2, 0]] if @is_on_baseline
    end
    @color == :w ? arr : arr.map { |x| x.map(&:-@) }
  end

  def impossible_move?(values, to)
    @is_on_baseline = row == @baseline
    @en_passant = perform_en_passant?(values[row][to[1]])
    @is_capturing = values[to].is_a?(Piece) || @en_passant
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

  def perform_en_passant?(node)
    node.is_a?(Pawn) && node.en_passant_vulnerable?
  end

  def en_passant_vulnerable?
    @two_square_opening
  end

  def en_passant_performed?
    @en_passant
  end

  def at_last_rank?
    row == @last_rank
  end
end
