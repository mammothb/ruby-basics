# frozen_string_literal: true

require_relative 'pieces/pieces.rb'
require_relative 'board_helper.rb'
require_relative 'board_values.rb'

# This class handles the location of game pieces and checks if move
# inputs are valid
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
    if move.key?(:king)
      execute_castling(move)
    elsif pawn?.call(@values[move[:from]])
      execute_pawn_move(move)
    else
      move_piece(move)
    end
    reset_opponent_en_passant(@values[move[:to]].color)
  end

  def execute_castling(move)
    move_piece(move[:king])
    move_piece(move[:rook])
  end

  def execute_pawn_move(move)
    move_piece(move)
    perform_en_passant(move[:to])
    vulnerable_to_en_passant(move)
  end

  def perform_en_passant(pos)
    return unless @values[pos].en_passant_performed?

    captured_pawn = all_pieces.select(&pawn?).find(&:en_passant_vulnerable?)
    @values[captured_pawn.pos] = EMPTY
  end

  def vulnerable_to_en_passant(move)
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

  def move_piece(move)
    @values[move[:to]] = @values[move[:from]]
    @values[move[:to]].pos = move[:to]
    @values[move[:to]].moved = true
    @values[move[:from]] = EMPTY
  end

  #####################################################################
  # Boolean methods
  #####################################################################
  def valid_move?(move, color)
    return valid_castling?(move, color) if move.key?(:king)

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
    col_between = exclusive_range(king[1], move[:rook][:from][1])
    result = false
    if checked?(color)
      print 'King is in check: '
    elsif @values[king].moved?
      print 'King was moved this game: '
    elsif !@values[move[:rook][:from]].is_a?(Rook) ||
          @values[move[:rook][:from]].moved?
      print 'Rook was moved this game: '
    elsif col_between.reject { |j| j == king[1] }
                     .any? { |j| @values[king[0]][j].is_a?(Piece) }
      print 'There are pieces between the king and rook: '
    elsif col_between.any? { |j| predict_checked?(king, [king[0], j], color) }
      print 'Cannot castle through check: '
    else
      result = true
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
