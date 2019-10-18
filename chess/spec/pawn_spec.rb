require "./lib/pieces/pieces.rb"

RSpec.describe Pawn do
  describe "#impossible_move?" do
    def moves(row, col, is_on_baseline, is_capturing, is_white)
      directions = [[1, 0]]
      directions += [[2, 0]] if is_on_baseline
      directions += [[1, 1], [1, -1]] if is_capturing
      directions.map! { |x| x.map { |i| -i } } unless is_white
      directions.select do |i, j|
        (row + i).between?(0, 7) && (col + j).between?(0, 7)
      end.map { |i, j| [row + i, col + j] }
    end
    
    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          white_piece = Pawn.new(:w, [row, col])
          black_piece = Pawn.new(:b, [row, col])
          moves(row, col, row == 1, false, true).each do |pos|
            expect(white_piece.impossible_move?(pos, false)).to eql(false)
          end
          moves(row, col, row == 6, false, false).each do |pos|
            expect(black_piece.impossible_move?(pos, false)).to eql(false)
          end
          moves(row, col, row == 1, true, true).each do |pos|
            expect(white_piece.impossible_move?(pos, true)).to eql(false)
          end
          moves(row, col, row == 1, true, false).each do |pos|
            expect(black_piece.impossible_move?(pos, true)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          white_piece = Pawn.new(:w, [row, col])
          black_piece = Pawn.new(:b, [row, col])
          (all_moves - moves(row, col, row == 1, false, true) -
              [row, col]).each do |pos|
            expect(white_piece.impossible_move?(pos, false)).to eql(true)
          end
          (all_moves - moves(row, col, row == 6, false, false) -
              [row, col]).each do |pos|
            expect(black_piece.impossible_move?(pos, false)).to eql(true)
          end
          (all_moves - moves(row, col, row == 1, true, true) -
              [row, col]).each do |pos|
            expect(white_piece.impossible_move?(pos, true)).to eql(true)
          end
          (all_moves - moves(row, col, row == 6, true, false) -
              [row, col]).each do |pos|
            expect(black_piece.impossible_move?(pos, true)).to eql(true)
          end
        end
      end
    end
  end

  describe "#obstructed?" do
    def moves(row, col)
      directions = [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [-1, 1],
        [-1, -1], [1, -1]]
      result = []
      (1..7).each do |n|
        result += directions.select do |i, j|
          (row + i * n).between?(0, 7) && (col + j * n).between?(0, 7)
        end.map { |i, j| [row + i * n, col + j * n] }
      end
      result
    end

    board = Board.new
    pawn = Pawn.new(:w)

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    8.times do |j|
      if j % 2 == 0
        board[2][j] = pawn
      else
        board[5][j] = pawn
      end
    end

    it "returns true when there's another piece in the way" do
      8.times do |j|
        white_pawn = Pawn.new(:w, [1, j])
        black_pawn = Pawn.new(:b, [6, j])
        if j % 2 == 0
          expect(white_pawn.obstructed?(board, [3, j])).to eql(true)
        else
          expect(black_pawn.obstructed?(board, [4, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      8.times do |j|
        white_pawn = Pawn.new(:w, [1, j])
        black_pawn = Pawn.new(:b, [6, j])
        if j % 2 == 0
          expect(black_pawn.obstructed?(board, [4, j])).to eql(false)
        else
          expect(white_pawn.obstructed?(board, [3, j])).to eql(false)
        end
        7.times do |i|
          white_pawn = Pawn.new(:w, [i, j])
          black_pawn = Pawn.new(:b, [7 - i, j])
          expect(white_pawn.obstructed?(board, [i + 1, j])).to eql(false)
          expect(black_pawn.obstructed?(board, [7 - i - 1, j])).to eql(false)
        end
      end
    end
  end
end
