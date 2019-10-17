require "./lib/chess_piece.rb"

RSpec.describe King do
  describe "#impossible_move?" do
    def moves(row, col)
      [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [-1, 1], [-1, -1],
          [1, -1]].select do |i, j|
        (row + i).between?(0, 7) && (col + j).between?(0, 7)
      end.map { |i, j| [row + i, col + j] }
    end

    piece = King.new(:white)

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end
  end

  describe "#obstructed?" do
    board = Board.new
    piece = King.new("white")

    it "returns false always" do
      8.times do |row|
        8.times do |col|
          8.times do |i|
            8.times do |j|
              expect(piece.obstructed?(board, [row, col],
                [i, j])).to eql(false)
            end
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

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
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
    piece = Queen.new("white")
    pawn = Pawn.new("white")

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    board[1][2] = pawn
    board[1][4] = pawn
    board[1][6] = pawn
    board[3][2] = pawn
    board[3][4] = piece
    board[3][6] = pawn
    board[6][1] = pawn
    board[6][4] = pawn
    board[5][6] = pawn
    pos = [3, 4]

    it "returns true when there's another piece in the way" do
      moves(*pos).each do |i, j|
        if i == 0 || (i == 3 && (j < 2 || j > 6)) || (i == 6 && j > 6) ||
            (i == 7 && j < 5)
          expect(piece.obstructed?(board, pos, [i, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      moves(*pos).each do |i, j|
        unless i == 0 || (i == 3 && (j < 2 || j > 6)) || (i == 6 && j > 6) ||
            (i == 7 && j < 5)
          expect(piece.obstructed?(board, pos, [i, j])).to eql(false)
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

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end
  end

  describe "#obstructed?" do
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

    board = Board.new
    piece = Rook.new("white")
    pawn = Pawn.new("white")

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    board[1][4] = pawn
    board[3][2] = pawn
    board[3][4] = piece
    board[3][6] = pawn
    board[6][4] = pawn
    pos = [3, 4]

    it "returns true when there's another piece in the way" do
      moves(*pos).each do |i, j|
        if i == 0 || (i == 3 && (j < 2 || j > 6)) || i == 7
          expect(piece.obstructed?(board, pos, [i, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      moves(*pos).each do |i, j|
        unless i == 0 || (i == 3 && (j < 2 || j > 6)) || i == 7
          expect(piece.obstructed?(board, pos, [i, j])).to eql(false)
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

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
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
    piece = Bishop.new("white")
    pawn = Pawn.new("white")

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    board[1][2] = pawn
    board[1][6] = pawn
    board[3][4] = piece
    board[6][1] = pawn
    board[5][6] = pawn
    pos = [3, 4]

    it "returns true when there's another piece in the way" do
      moves(*pos).each do |i, j|
        if i == 0 || (i == 6 && j > 6) || i == 7
          expect(piece.obstructed?(board, pos, [i, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      moves(*pos).each do |i, j|
        unless i == 0 || (i == 6 && j > 6) || i == 7
          expect(piece.obstructed?(board, pos, [i, j])).to eql(false)
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

    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col).each do |i, j|
            expect(piece.impossible_move?([row, col], [i, j],
              false)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col) - [row, col]).each do |pos|
            expect(piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
        end
      end
    end
  end

  describe "#obstructed?" do
    board = Board.new
    piece = Knight.new("white")

    it "returns false always" do
      8.times do |row|
        8.times do |col|
          8.times do |i|
            8.times do |j|
              expect(piece.obstructed?(board, [row, col],
                [i, j])).to eql(false)
            end
          end
        end
      end
    end
  end
end

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

    white_piece = Pawn.new("white")
    black_piece = Pawn.new("black")
    
    it "returns false when destination is reachable" do
      8.times do |row|
        8.times do |col|
          moves(row, col, row == 1, false, true).each do |pos|
            expect(white_piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
          moves(row, col, row == 6, false, false).each do |pos|
            expect(black_piece.impossible_move?([row, col], pos,
              false)).to eql(false)
          end
          moves(row, col, row == 1, true, true).each do |pos|
            expect(white_piece.impossible_move?([row, col], pos,
              true)).to eql(false)
          end
          moves(row, col, row == 1, true, false).each do |pos|
            expect(black_piece.impossible_move?([row, col], pos,
              true)).to eql(false)
          end
        end
      end
    end

    it "returns true when destination cannot not be reached" do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      8.times do |row|
        8.times do |col|
          (all_moves - moves(row, col, row == 1, false, true) -
              [row, col]).each do |pos|
            expect(white_piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
          (all_moves - moves(row, col, row == 6, false, false) -
              [row, col]).each do |pos|
            expect(black_piece.impossible_move?([row, col], pos,
              false)).to eql(true)
          end
          (all_moves - moves(row, col, row == 1, true, true) -
              [row, col]).each do |pos|
            expect(white_piece.impossible_move?([row, col], pos,
              true)).to eql(true)
          end
          (all_moves - moves(row, col, row == 6, true, false) -
              [row, col]).each do |pos|
            expect(black_piece.impossible_move?([row, col], pos,
              true)).to eql(true)
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
    white_pawn = Pawn.new("white")
    black_pawn = Pawn.new("black")

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    8.times do |j|
      if j % 2 == 0
        board[2][j] = white_pawn
      else
        board[5][j] = black_pawn
      end
    end

    it "returns true when there's another piece in the way" do
      8.times do |j|
        if j % 2 == 0
          expect(white_pawn.obstructed?(board, [1, j], [3, j])).to eql(true)
        else
          expect(black_pawn.obstructed?(board, [6, j], [4, j])).to eql(true)
        end
      end
    end

    it "returns false when there's nothing in the way" do
      8.times do |j|
        if j % 2 == 0
          expect(black_pawn.obstructed?(board, [6, j], [4, j])).to eql(false)
        else
          expect(white_pawn.obstructed?(board, [1, j], [3, j])).to eql(false)
        end
        7.times do |i|
          expect(white_pawn.obstructed?(board, [i, j],
            [i + 1, j])).to eql(false)
            expect(black_pawn.obstructed?(board, [7 - i, j],
              [7 - i - 1, j])).to eql(false)
        end
      end
    end
  end
end
