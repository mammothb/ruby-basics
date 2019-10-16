require_relative "chess_piece.rb"

class Board
  SIZE = 8.freeze
  # PIECES = {
  #   KING: { W: "\u2654", B: "\u265A" },
  #   QUEEN: { W: "\u2655", B: "\u265B" },
  #   ROOK: { W: "\u2656", B: "\u265C" },
  #   BISHOP: { W: "\u2657", B: "\u265D" },
  #   KNIGHT: { W: "\u2658", B: "\u265E" },
  #   PAWN: { W: "\u2659", B: "\u265F" }
  # }.freeze

  # PIECES_BY_COLOR = {
  #   W: {
  #     KING: "\u2654",
  #     QUEEN: "\u2655",
  #     ROOK: "\u2656",
  #     BISHOP: "\u2657",
  #     KNIGHT: "\u2658",
  #     PAWN: "\u2659"
  #   },
  #   B: {
  #     KING: "\u265A",
  #     QUEEN: "\u265B",
  #     ROOK: "\u265C",
  #     BISHOP: "\u265D",
  #     KNIGHT: "\u265E",
  #     PAWN: "\u265F"
  #   }
  # }.freeze

  def self.in_bounds?(i, j)
    i.between?(0, SIZE - 1) && j.between?(0, SIZE - 1)
  end

  def initialize
    @values = Array.new(SIZE) { Array.new(SIZE, " ") }
    SIZE.times do |i|
      @values[1][i] = Pawn.new("white")
      @values[6][i] = Pawn.new("black")
    end
    [Rook, Knight, Bishop].each_with_index do |piece, i|
      @values[0][i] = piece.new("white")
      @values[0][SIZE - i - 1] = piece.new("white")
      @values[7][i] = piece.new("black")
      @values[7][SIZE - i - 1] = piece.new("black")
    end
    @values[0][3] = Queen.new("white")
    @values[0][4] = King.new("white")
    @values[7][3] = Queen.new("black")
    @values[7][4] = King.new("black")
  end

  def [](index)
    if index.length == 2
      @values[index[1]][index[0]]
    elsif index.kind_of?(Integer)
      @values[index]
    else
      raise TypeError, "Invalid index"
    end
  end

  def valid_move?(move, color)
    result = false
    if out_of_bounds?(move)
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
      result = true
    end
    result
  end

  def out_of_bounds?(move)
    move.any? { |k, pos| pos.any? { |x| x.nil? } }
  end

  def empty_selection?(pos)
    self[pos] == " "
  end

  def belong_to_player?(pos, color)
    self[pos].color == color
  end

  def same_color?(from, to)
    self[from].color ==
      (self[to].kind_of?(ChessPiece) ? self[to].color : self[to])
  end

  def reachable?(from, to)
    result = false
    if self[from].impossible_move?(from, to, self[to].kind_of?(ChessPiece))
      print "The selected game piece (#{self[move[:from]].symbol} ) " +
        "cannot move that way: "
    elsif self[from].obstructed?(from, to)
      print "Another game piece is in the way: "
    else
      result = true
    end
    result
  end

  def to_s
    result = "\n"
    @values.reverse.each_with_index do |row, i|
      result += "#{SIZE - i} | "
      result += row.map do |piece|
        piece.kind_of?(ChessPiece) ? piece.symbol : piece
      end.join(" | ")
      result += " |\n"
    end
    result += "    #{("A".."H").to_a.join("   ")}"
  end
end