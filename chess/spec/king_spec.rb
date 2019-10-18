require "./lib/pieces/pieces.rb"

RSpec.describe King do
  describe "#impossible_move?" do
    def moves(row, col)
      [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [-1, 1], [-1, -1],
          [1, -1]].select do |i, j|
        (row + i).between?(0, 7) && (col + j).between?(0, 7)
      end.map { |i, j| [row + i, col + j] }
    end

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            piece = King.new(:w, [row, col])
            expect(piece.impossible_move?(pos, false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          piece = King.new(:w, [row, col])
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?(pos, false)).to eql(true)
          end
        end
      end
    end
  end

  describe "#obstructed?" do
    board = Board.new

    it "returns false when destination is empty" do
      8.times do |row|
        8.times do |col|
          piece = King.new(:w, [row, col])
          8.times do |i|
            8.times do |j|
              if board[i][j] == " " || board[i][j].color == :b
                expect(piece.obstructed?(board, [i, j])).to eql(false)
              end
            end
          end
        end
      end
    end

    it "returns false when destination is occupied by ally" do
      8.times do |row|
        8.times do |col|
          piece = King.new(:w, [row, col])
          8.times do |i|
            8.times do |j|
              if board[i][j].is_a?(Piece) && board[i][j].color == :w
                expect(piece.obstructed?(board, [i, j])).to eql(true)
              end
            end
          end
        end
      end
    end
  end
end
