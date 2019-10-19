# frozen_string_literal: true

class BoardValues
  def initialize(size, initial_value)
    @values = Array.new(size) { Array.new(size, initial_value) }
  end

  def [](index)
    if index.is_a?(Integer)
      @values[index]
    elsif coordinate?(index)
      @values[index[0]][index[1]]
    else
      invalid_index_error
    end
  end

  def []=(index, value)
    if coordinate?(index)
      @values[index[0]][index[1]] = value
    else
      invalid_index_error
    end
  end

  def flatten
    @values.flatten
  end

  def reverse
    @values.reverse
  end

  private

  def coordinate?(index)
    index.is_a?(Array) && index.length == 2
  end

  def invalid_index_error
    raise TypeError, 'Invalid index!'
  end
end
