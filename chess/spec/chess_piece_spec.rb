require "./lib/chess_piece.rb"

RSpec.describe King do
  describe "#impossible_move?" do
    def moves(row, col)
      [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [-1, 1], [-1, -1], [1, -1]
      ].select do |i, j|
        (row + i).between?(0, 7) && (col + j).between?(0, 7)
      end.map { |i, j| [row + i, col + j] }
    end

    piece = King.new("white")

    it "returns true when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end

    it "returns false when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end
  end
end

RSpec.describe Queen do
  describe "#impossible_move?" do
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

    piece = Queen.new("white")

    it "returns true when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end

    it "returns false when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end
  end
end

RSpec.describe Rook do
  describe "#impossible_move?" do
    def moves(row, col)
      directions = [[0, 1], [0, -1], [-1, 0], [1, 0]]
      result = []
      (1..7).each do |n|
        result += directions.select do |i, j|
          (row + i * n).between?(0, 7) && (col + j * n).between?(0, 7)
        end.map { |i, j| [row + i * n, col + j * n] }
      end
      result
    end

    piece = Rook.new("white")

    it "returns true when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end

    it "returns false when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end
  end
end

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

    piece = Bishop.new("white")

    it "returns true when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end

    it "returns false when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end
  end
end

RSpec.describe Knight do
  describe "#impossible_move?" do
    def moves(row, col)
      [[2, -1], [2, 1], [-2, -1], [-2, 1], [-1, 2], [1, 2], [-1, -2], [1, -2]
      ].select do |i, j|
        (row + i).between?(0, 7) && (col + j).between?(0, 7)
      end.map { |i, j| [row + i, col + j] }
    end

    piece = Knight.new("white")

    it "returns true when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |i, j|
            expect(piece.impossible_move?([row, col], [i, j],
              false)).to eql(true)
          end
        end
      end
    end

    it "returns false when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end
  end
end

RSpec.describe Pawn do
  describe "#impossible_move?" do
    def moves(row, col)
      [[0, 1]].select do |i, j|
        (row + i).between?(0, 7) && (col + j).between?(0, 7)
      end.map { |i, j| [row + i, col + j] }
    end

    piece = Pawn.new("white")

    it "returns true when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |i, j|
            expect(piece.impossible_move?([row, col], [i, j],
              false)).to eql(true)
          end
        end
      end
    end

    it "returns false when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end
  end
end
