# frozen_string_literal: true

require './lib/board.rb'
require './lib/pieces/pieces.rb'

RSpec.describe Bishop do
  def all_board_pos
    (0..7).to_a.repeated_permutation(2).to_a
  end

  def moves(row, col)
    d = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    result = []
    (1..7).each do |n|
      result += d.select { |i, j| Board.in_bounds?(row + i * n, col + j * n) }
                 .map { |i, j| [row + i * n, col + j * n] }
    end
    result
  end

  describe '#impossible_move?' do
    it 'returns false when destination is reachable' do
      all_board_pos.each do |row, col|
        piece = Bishop.new(:w, [row, col])
        moves(row, col).each do |pos|
          expect(piece.impossible_move?([], pos)).to eql(false)
        end
      end
    end

    it 'returns true when destination cannot not be reached' do
      all_board_pos.each do |row, col|
        piece_pos = [row, col]
        piece = Bishop.new(:w, piece_pos)
        (all_board_pos - moves(row, col) - piece_pos).each do |pos|
          expect(piece.impossible_move?([], pos)).to eql(true)
        end
      end
    end
  end

  describe '#obstructed?' do
    board = Board.new
    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }

    piece = Bishop.new(:w, [3, 4])
    pos = piece.pos

    board.place(Pawn.new(:w, [1, 2]))
    board.place(Pawn.new(:w, [1, 6]))
    board.place(piece)
    board.place(Pawn.new(:w, [6, 1]))
    board.place(Pawn.new(:w, [5, 6]))

    it "returns true when there's another piece in the way" do
      moves(*pos).each do |i, j|
        if i.zero? || (i == 6 && j > 6) || i == 7
          expect(piece.obstructed?(board, [i, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      moves(*pos).each do |i, j|
        unless i.zero? || (i == 6 && j > 6) || i == 7
          expect(piece.obstructed?(board, [i, j])).to eql(false)
        end
      end
    end
  end
end
