require_relative "pieces/pieces.rb"
require_relative "board_helper.rb"
require_relative "board_values.rb"

class Board
  SIZE = 8.freeze
  EMPTY = " ".freeze
  KING = { w: "\u2654", b: "\u265A" }.freeze

  include BoardHelper

  def self.in_bounds?(i, j)
    i.between?(0, SIZE - 1) && j.between?(0, SIZE - 1)
  end

  def initialize
    @values = BoardValues.new(SIZE, EMPTY)
    all_pieces = []
    SIZE.times do |i|
      all_pieces.push(Pawn.new(:w, [1, i]))
      all_pieces.push(Pawn.new(:b, [6, i]))
    end
    [Rook, Knight, Bishop].each_with_index do |piece, i|
      all_pieces.push(piece.new(:w, [0, i]))
      all_pieces.push(piece.new(:w, [0, SIZE - i - 1]))
      all_pieces.push(piece.new(:b, [7, i]))
      all_pieces.push(piece.new(:b, [7, SIZE - i - 1]))
    end
    [:w, :b].zip([0, 7]).each do |color, i|
      all_pieces.push(Queen.new(color, [i, 3]))
      all_pieces.push(King.new(color, [i, 4]))
    end
    all_pieces.each { |piece| @values[piece.pos] = piece }
  end

  def [](index)
    @values[index]
  end

  def []=(index, value)
    @values[index] = value
  end

  def valid_move?(move, color)
    result = false
    if include_nil?(move)
      print "Keep within board size (a..h/1..8): "
    elsif empty_selection?(move[:from])
      print "Failed to select a game piece: "
    elsif !belong_to_player?(move[:from], color)
      print "That game piece (#{symbol(move[:from])} ) is not yours: "
    elsif same_color?(*move.values)
      print "Destination occupied (#{symbol(move).join(" =>")} ): "
    elsif reachable?(*move.values)
      if predict_checked?(move[:from], move[:to], color)
        print "You will be checked if you do that: "
      else
        result = true
      end
    end
    result
  end

  def empty_selection?(pos)
    @values[pos] == EMPTY
  end

  def belong_to_player?(pos, color)
    @values[pos].color == color
  end

  def same_color?(from, to)
    @values[to].is_a?(Piece) && @values[from].color == @values[to].color
  end

  def reachable?(from, to, quiet = false)
    result = false
    if @values[from].impossible_move?(to, @values[to].is_a?(Piece))
      print "#{symbol(index)} cannot move that way: " unless quiet
    elsif @values[from].obstructed?(@values, to)
      print "Another game piece is in the way: " unless quiet
    else
      result = true
    end
    result
  end

  def reachable_by_opponent?(to, color)
    opponent_pieces(color).any? { |piece| reachable?(piece.pos, to, true) }
  end

  def predict_checked?(from, to, color)
    original_values = Marshal.dump(@values)
    make_move({ from: from, to: to})

    result = checked?(color)
    @values = Marshal.load(original_values)
    result
  end

  def checked?(color)
    reachable_by_opponent?(king_pos(color), color)
  end

  def escape_checked?(color)
    player_pieces(color).all? do |piece|
      piece.all_possible_moves(@values).all? do |to|
        predict_checked?(piece.pos, to, color)
      end
    end
  end

  def all_pieces
    @values.flatten.select(&is_a_piece?)
  end

  def king_pos(color)
    all_pieces.find { |piece| piece.symbol == KING[color] }.pos
  end

  def opponent_pieces(color)
    all_pieces.select { |piece| piece.color != color }
  end

  def player_pieces(color)
    all_pieces.select { |piece| piece.color == color }
  end

  def make_move(move)
    @values[move[:to]] = @values[move[:from]]
    @values[move[:to]].pos = move[:to]
    @values[move[:from]] = EMPTY
  end

  def symbol(index)
    if index.is_a?(Hash)
      index.values.map { |pos| @values[pos].symbol }
    else
      @values[index].symbol
    end
  end

  def to_s
    print_board(@values, SIZE)
  end
end