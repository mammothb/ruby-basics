# frozen_string_literal: true

module PieceHelper
  # Returns the vector distance between "from" and "to"
  def distance_vector(from, to)
    [to, from].transpose.map { |x| x.reduce(:-) }
  end
end
