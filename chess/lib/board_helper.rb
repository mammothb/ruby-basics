# frozen_string_literal: true

require_relative './pieces/pieces.rb'

module BoardHelper
  def piece?
    proc { |node| node.is_a?(Piece) }
  end

  def pawn?
    proc { |node| node.is_a?(Pawn) }
  end

  # Returns true if any element the move hash is nil
  #
  # nil elements are a result of chess move notation going beyond the
  # limit of a..h/1..8
  def include_nil?(move)
    move.values.flatten.include?(nil)
  end

  def exclusive_range(start, stop)
    result = []
    incr = (stop - start) / (stop - start).abs
    i = start + incr
    while i != stop
      result << i
      i += incr
    end
    result
  end

  def file_indicator
    "    #{('A'..'H').to_a.join('   ')}"
  end

  def left_rank_indicator(rank)
    rank_indicator(rank, true)
  end

  def right_rank_indicator(rank)
    rank_indicator(rank, false)
  end

  def rank_indicator(rank, left)
    left ? "#{rank} | " : " | #{rank}"
  end

  def horizontal_line(size)
    "  +-#{(['-'] * size).join('-+-')}-+\n"
  end
end
