require "./lib/pieces/pieces.rb"

RSpec.describe Bishop do
  describe "#impossible_move?" do
    def moves(row, col)
      directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
      result = []
      (1..7).each do |n|
        result += directions.select do |i, j|
          (row + i * n).between?(0, 7) && (col + j * n).between?(0, 7)
        end.map { |i, j| [row + i * n, col + j * n] }
      end
      result
    end

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          piece = Bishop.new(:w, [row, col])
          moves(row, col).each do |pos|
            expect(piece.impossible_move?(pos, false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          piece = Bishop.new(:w, [row, col])
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?(pos, false)).to eql(true)
          end
        end
      end
    end
  end

  describe "#obstructed?" do
    def moves(row, col)
      directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
      result = []
      (1..7).each do |n|
        result += directions.select do |i, j|
          (row + i * n).between?(0, 7) && (col + j * n).between?(0, 7)
        end.map { |i, j| [row + i * n, col + j * n] }
      end
      result
    end

    board = Board.new
    piece = Bishop.new(:w, [3, 4])

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    board[1][2] = Pawn.new(:w, [1, 2])
    board[1][6] = Pawn.new(:w, [1, 6])
    board[3][4] = piece
    board[6][1] = Pawn.new(:w, [6, 1])
    board[5][6] = Pawn.new(:w, [5, 6])
    pos = [3, 4]

    it "returns true when there's another piece in the way" do
      moves(*pos).each do |i, j|
        if i == 0 || (i == 6 && j > 6) || i == 7
          expect(piece.obstructed?(board, [i, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      moves(*pos).each do |i, j|
        unless i == 0 || (i == 6 && j > 6) || i == 7
          expect(piece.obstructed?(board, [i, j])).to eql(false)
        end
      end
    end
  end
end
