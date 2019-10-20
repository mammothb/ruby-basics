# frozen_string_literal: true

require_relative 'pieces/pieces.rb'
require_relative 'board_helper.rb'
require_relative 'board_values.rb'

class Board
  include BoardHelper

  SIZE = 8
  EMPTY = ' '
  KING = { w: "\u2654", b: "\u265A" }.freeze

  def self.in_bounds?(row, col)
    row.between?(0, SIZE - 1) && col.between?(0, SIZE - 1)
  end

  def initialize
    @values = BoardValues.new(SIZE, EMPTY)
    setup_board
  end

  def [](index)
    @values[index]
  end

  def []=(index, value)
    @values[index] = value
  end

  def execute_move(move)
    @values[move[:to]] = @values[move[:from]]
    @values[move[:to]].pos = move[:to]
    @values[move[:to]].moved = true
    @values[move[:from]] = EMPTY
    handle_en_passant(move) if pawn?.call(@values[move[:to]])
    reset_opponent_en_passant(@values[move[:to]].color)
  end

  def handle_en_passant(move)
    if @values[move[:to]].en_passant_performed?
      captured_pawn = all_pieces.select(&pawn?).find(&:en_passant_vulnerable?)
      @values[captured_pawn.pos] = EMPTY
    end

    return unless move.values.transpose[0].reduce(:-).abs == 2

    @values[move[:to]].two_square_opening = true
  end

  def reset_opponent_en_passant(color)
    opponent_pieces(color).select(&pawn?)
                          .each { |piece| piece.two_square_opening = false }
  end

  def place(piece)
    @values[piece.pos] = piece
  end

  #####################################################################
  # Boolean methods
  #####################################################################
  def valid_move?(move, color)
    return valid_castling?(move, color) if move.key?(:castle)

    result = false
    if include_nil?(move)
      print 'Keep within board size (a..h/1..8): '
    elsif empty_selection?(move[:from])
      print 'Failed to select a game piece: '
    elsif !belong_to_player?(move[:from], color)
      print "That game piece (#{symbol(move[:from])} ) is not yours: "
    elsif same_color?(*move.values)
      print "Destination occupied (#{symbol(move).join(' =>')} ): "
    elsif reachable?(*move.values)
      if predict_checked?(move[:from], move[:to], color)
        print 'You will be checked if you do that: '
      else
        result = true
      end
    end
    result
  end

  def valid_castling?(move, color)
    king = king_pos(color)
    rook = [king[0], move[:castle]]
    col_between = exclusive_range(king[1], rook[1])
    p exclusive_range(king[1], rook[1])
    if @values[king].moved?
      p 'king moved'
    elsif !@values[rook].is_a?(Rook) ||
          (@values[rook].is_a?(Rook) && @values[rook_loc].moved?)
      p 'rook moved'
    elsif col_between.any? { |j| @values[king[0]][j].is_a?(Piece) }
      p 'piece in between'
    end
    # Missing predict check for spaces in between
    false
  end

  def empty_selection?(pos)
    @values[pos] == EMPTY
  end

  def belong_to_player?(pos, color)
    @values[pos].color == color
  end

  def same_color?(from, to)
    piece?.call(@values[to]) && @values[from].color == @values[to].color
  end

  def reachable?(from, to, quiet = false)
    result = false
    if @values[from].impossible_move?(@values, to)
      print "#{symbol(from)} cannot move that way: " unless quiet
    elsif @values[from].obstructed?(@values, to)
      print 'Another game piece is in the way: ' unless quiet
    else
      result = true
    end
    result
  end

  def reachable_by_opponent?(to, color)
    opponent_pieces(color).any? { |piece| reachable?(piece.pos, to, true) }
  end

  def predict_checked?(from, to, color)
    original_values = Marshal.load(Marshal.dump(@values))
    execute_move(from: from, to: to)

    result = checked?(color)
    @values = original_values
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

  #####################################################################
  # Getters
  #####################################################################
  def all_pieces
    @values.flatten.select(&piece?)
  end

  def king_pos(color)
    all_pieces.find { |piece| piece.symbol == KING[color] }.pos
  end

  def opponent_pieces(color)
    all_pieces.reject { |piece| piece.color == color }
  end

  def player_pieces(color)
    all_pieces.select { |piece| piece.color == color }
  end

  def symbol(index)
    if index.is_a?(Hash)
      index.values.map { |pos| @values[pos].symbol }
    else
      @values[index].symbol
    end
  end

  def to_s
    result = "\n#{file_indicator}\n#{horizontal_line(SIZE)}"
    @values.reverse.each_with_index do |row, i|
      result += left_rank_indicator(SIZE - i) + row.map do |piece|
        piece?.call(piece) ? piece.symbol : piece
      end.join(' | ')
      result += "#{right_rank_indicator(SIZE - i)}\n#{horizontal_line(SIZE)}"
    end
    result += file_indicator
  end

  private

  def setup_board
    place_piece = proc { |piece| place(piece) }
    create_pieces.each(&place_piece)
  end

  def create_pieces
    pawns.tap do |arr|
      [Rook, Knight, Bishop, Queen, King].each_with_index do |piece, j|
        j_rev = SIZE - j - 1
        %i[w b].zip([0, 7]).each do |c, i|
          arr << piece.new(c, [i, j])
          arr << piece.new(c, [i, j_rev]) unless [Queen, King].include?(piece)
        end
      end
    end
  end

  def pawns
    [].tap do |arr|
      SIZE.times do |j|
        %i[w b].zip([1, 6]).each { |c, i| arr << Pawn.new(c, [i, j]) }
      end
    end
  end
end
