# frozen_string_literal: true

require_relative '../board.rb'
require_relative 'piece_helper.rb'
require_relative 'movement.rb'

class Piece
  include PieceHelper

  attr_accessor :pos
  attr_reader :color, :symbol
  attr_writer :moved

  def initialize(symbol, color, pos)
    unless %i[w b].include?(color)
      raise ArgumentError, 'Piece color must be :w or :b'
    end

    @symbol = symbol[color]
    @color = color
    @pos = pos
    @moved = false
  end

  def row
    pos[0]
  end

  def col
    pos[1]
  end

  def opponent?(other_piece)
    color != other_piece.color
  end

  def moved?
    @moved
  end

  def impossible_move?(_values, to)
    if distance == 1
      !directions.include?(distance_vector(pos, to))
    elsif pos != to
      # Convert to absolute for easier calculations and since
      # directions for MultiStep movements are mirrored
      direction = distance_vector(pos, to).map(&:abs)
      min_mag = direction.reject(&:zero?).min
      !directions.include?(direction.map { |x| (x.to_f / min_mag).ceil })
    else
      true
    end
  end

  def obstructed?(values, to)
    if distance > 1
      direction = distance_vector(pos, to)
      steps = direction.map(&:abs).max
      direction.map! { |x| x / steps }
      (1...steps).map { |n| pos.zip(direction).map { |x, d| x + d * n } }
                 .any? { |i, j| values[i][j].is_a?(Piece) }
    else
      values[to].is_a?(Piece) && !opponent?(values[to])
    end
  end

  def all_possible_moves(values)
    (1..distance).map do |n|
      directions.map do |di, dj|
        pos = [row + n * di, col + n * dj]
        if Board.in_bounds?(*pos) && !obstructed?(values, pos) &&
           (!values[pos].is_a?(Piece) || opponent?(values[pos]))
          pos
        end
      end
    end.flatten(1).compact
  end
end
