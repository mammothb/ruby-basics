require_relative "chess_piece.rb"
require_relative "board_helper.rb"

class Board
  SIZE = 8.freeze
  EMPTY = " ".freeze
  KING = { white: "\u2654", black: "\u265A" }.freeze

  def self.in_bounds?(i, j)
    i.between?(0, SIZE - 1) && j.between?(0, SIZE - 1)
  end

  def initialize
    @values = Array.new(SIZE) { Array.new(SIZE, EMPTY) }
    SIZE.times do |i|
      @values[1][i] = Pawn.new(:white, [1, i])
      @values[6][i] = Pawn.new(:black, [6, i])
    end
    [Rook, Knight, Bishop].each_with_index do |piece, i|
      @values[0][i] = piece.new(:white, [0, i])
      @values[0][SIZE - i - 1] = piece.new(:white, [0, SIZE - i - 1])
      @values[7][i] = piece.new(:black, [7, i])
      @values[7][SIZE - i - 1] = piece.new(:black, [7, SIZE - i - 1])
    end
    @values[0][3] = Queen.new(:white, [0, 3])
    @values[0][4] = King.new(:white, [0, 4])
    @values[7][3] = Queen.new(:black, [7, 3])
    @values[7][4] = King.new(:black, [7, 4])
  end

  def [](index)
    if index.is_a?(Integer)
      @values[index]
    elsif index.length == 2
      @values[index[0]][index[1]]
    else
      raise TypeError, "Invalid index"
    end
  end

  def []=(index, value)
    if index.is_a?(Array) && index.length == 2
      @values[index[0]][index[1]] = value
    else
      raise TypeError, "Invalid index"
    end
  end

  def valid_move?(move, color)
    result = false
    if include_nil?(move)
      print "Keep within board size (a..h/1..8): "
    elsif empty_selection?(move[:from])
      print "Failed to select a game piece: "
    elsif !belong_to_player?(move[:from], color)
      print "The selected game piece (#{self[move[:from]].symbol} ) " +
        "doesn't belong to you: "
    elsif same_color?(move[:from], move[:to])
      print "Destination occupied (#{self[move[:from]].symbol} =>" +
        "#{self[move[:to]].symbol} ): "
    elsif reachable?(move[:from], move[:to])
      if checked?(move[:from], move[:to], color)
        print "You will be checked if you do that: "
      else
        result = true
      end
    end
    result
  end

  def empty_selection?(pos)
    self[pos] == EMPTY
  end

  def belong_to_player?(pos, color)
    self[pos].color == color
  end

  def same_color?(from, to)
    self[to].is_a?(ChessPiece) && self[from].color == self[to].color
  end

  def reachable?(from, to)
    result = false
    if self[from].impossible_move?(from, to, self[to].is_a?(ChessPiece))
      print "The selected game piece (#{self[from].symbol} ) cannot move " +
        "that way: "
    elsif self[from].obstructed?(self, from, to)
      print "Another game piece is in the way: "
    else
      result = true
    end
    result
  end

  def checked?(from, to, color)
    if king_pos(color) == from
      p "Self king selected"
      opponent_pieces(color).any? do |piece|
        !piece.impossible_move?(piece.pos, to, true)
      end
    else

    end
  end

  def king_pos(color)
    @values.flatten.select { |node| node.is_a?(ChessPiece) }
      .find { |piece| piece.symbol == KING[color.to_sym] }.pos
  end

  def opponent_pieces(color)
    @values.flatten.select { |node| node.is_a?(ChessPiece) }
      .select { |piece| piece.color != color }
  end

  def make_move(move)
    self[move[:to]] = self[move[:from]]
    self[move[:to]].pos = move[:to]
    self[move[:from]] = EMPTY
  end

  def to_s
    result = "\n    #{("A".."H").to_a.join("   ")}\n"
    result += "  +-#{(["-"] * 8).join("-+-")}-+\n"
    @values.reverse.each_with_index do |row, i|
      result += "#{SIZE - i} | "
      result += row.map do |piece|
        piece.is_a?(ChessPiece) ? piece.symbol : piece
      end.join(" | ")
      result += " | #{SIZE - i}\n"
      result += "  +-#{(["-"] * 8).join("-+-")}-+\n"
    end
    result += "    #{("A".."H").to_a.join("   ")}"
  end
end