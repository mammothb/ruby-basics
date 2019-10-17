require "./lib/board.rb"
require "./lib/chess_piece.rb"

RSpec.describe "#include_nil?" do
  it "returns true when given a hash containing nil in its values" do
    moves = [{ from: [1, 2], to: [3, nil] },
             { from: [1, 2], to: [nil, 4] },
             { from: [1, nil], to: [3, 4] },
             { from: [nil, 2], to: [3, 4] },
             { from: [1, 2], to: [nil, nil] },
             { from: [nil, nil], to: [nil, 4] }]
    moves.each do |move|
      expect(include_nil?(move)).to eql(true)
    end
  end

  it "returns false when given a hash doesn't contain nil values" do
    moves = [{ from: [1, 2], to: [3, 4] },
             { from: [11, 12], to: [13, 14] }]
    moves.each do |move|
      expect(include_nil?(move)).to eql(false)
    end
  end
end

RSpec.describe Board do
  describe "::in_bounds?" do
    it "returns true if [i, j] is within the board's limits" do
      8.times do |row|
        8.times do |col|
          expect(Board.in_bounds?(row, col)).to eql(true)
        end
      end
    end

    it "returns false if [i, j] is outside the board's limits" do
      (-7..7).each do |row|
        (-7..7).each do |col|
          unless row.between?(0, 7) && col.between?(0, 7)
            expect(Board.in_bounds?(row, col)).to eql(false)
          end
        end
      end
    end
  end

  describe "#[]" do
    pieces = {
      white: {
        king: King.new(:white),
        queen: Queen.new(:white),
        rook: Rook.new(:white),
        bishop: Bishop.new(:white),
        knight: Knight.new(:white),
        pawn: Pawn.new(:white)
      },
      black: {
        king: King.new(:black),
        queen: Queen.new(:black),
        rook: Rook.new(:black),
        bishop: Bishop.new(:black),
        knight: Knight.new(:black),
        pawn: Pawn.new(:black)
      }
    }

    board = Board.new

    it "returns the proper node when given [row, col]" do
      expect(board[[0, 0]].symbol).to eql(pieces[:white][:rook].symbol)
      expect(board[[0, 7]].symbol).to eql(pieces[:white][:rook].symbol)
      expect(board[[0, 1]].symbol).to eql(pieces[:white][:knight].symbol)
      expect(board[[0, 6]].symbol).to eql(pieces[:white][:knight].symbol)
      expect(board[[0, 2]].symbol).to eql(pieces[:white][:bishop].symbol)
      expect(board[[0, 5]].symbol).to eql(pieces[:white][:bishop].symbol)
      expect(board[[0, 3]].symbol).to eql(pieces[:white][:queen].symbol)
      expect(board[[0, 4]].symbol).to eql(pieces[:white][:king].symbol)

      expect(board[[7, 0]].symbol).to eql(pieces[:black][:rook].symbol)
      expect(board[[7, 7]].symbol).to eql(pieces[:black][:rook].symbol)
      expect(board[[7, 1]].symbol).to eql(pieces[:black][:knight].symbol)
      expect(board[[7, 6]].symbol).to eql(pieces[:black][:knight].symbol)
      expect(board[[7, 2]].symbol).to eql(pieces[:black][:bishop].symbol)
      expect(board[[7, 5]].symbol).to eql(pieces[:black][:bishop].symbol)
      expect(board[[7, 3]].symbol).to eql(pieces[:black][:queen].symbol)
      expect(board[[7, 4]].symbol).to eql(pieces[:black][:king].symbol)

      8.times do |i|
        expect(board[[1, i]].symbol).to eql(pieces[:white][:pawn].symbol)
        expect(board[[6, i]].symbol).to eql(pieces[:black][:pawn].symbol)
      end
    end

    it "returns the proper node when given [row]" do
      expect(board[0][0].symbol).to eql(pieces[:white][:rook].symbol)
      expect(board[0][7].symbol).to eql(pieces[:white][:rook].symbol)
      expect(board[0][1].symbol).to eql(pieces[:white][:knight].symbol)
      expect(board[0][6].symbol).to eql(pieces[:white][:knight].symbol)
      expect(board[0][2].symbol).to eql(pieces[:white][:bishop].symbol)
      expect(board[0][5].symbol).to eql(pieces[:white][:bishop].symbol)
      expect(board[0][3].symbol).to eql(pieces[:white][:queen].symbol)
      expect(board[0][4].symbol).to eql(pieces[:white][:king].symbol)

      expect(board[7][0].symbol).to eql(pieces[:black][:rook].symbol)
      expect(board[7][7].symbol).to eql(pieces[:black][:rook].symbol)
      expect(board[7][1].symbol).to eql(pieces[:black][:knight].symbol)
      expect(board[7][6].symbol).to eql(pieces[:black][:knight].symbol)
      expect(board[7][2].symbol).to eql(pieces[:black][:bishop].symbol)
      expect(board[7][5].symbol).to eql(pieces[:black][:bishop].symbol)
      expect(board[7][3].symbol).to eql(pieces[:black][:queen].symbol)
      expect(board[7][4].symbol).to eql(pieces[:black][:king].symbol)

      8.times do |i|
        expect(board[1][i].symbol).to eql(pieces[:white][:pawn].symbol)
        expect(board[6][i].symbol).to eql(pieces[:black][:pawn].symbol)
      end
    end
  end

  describe "#empty_selection?" do
    board = Board.new
    pawn = Pawn.new(:white)
    # Set the board to have pieces that's not in the default position
    8.times do |row|
      8.times do |col|
        board[row][col] = (row * col) % 6 == 0 ? pawn : Board::EMPTY
      end
    end

    it "returns true when the position doesn't contain a ChessPiece" do
      8.times do |row|
        8.times do |col|
          unless (row * col) % 6 == 0
            expect(board.empty_selection?([row, col])).to eql(true)
          end
        end
      end
    end

    it "returns false when the position contains a ChessPiece" do
      8.times do |row|
        8.times do |col|
          if (row * col) % 6 == 0
            expect(board.empty_selection?([row, col])).to eql(false)
          end
        end
      end
    end
  end

  describe "#belong_to_player?" do
    board = Board.new
    white_pawn = Pawn.new(:white)
    black_pawn = Pawn.new(:black)
    # Set the board to have pieces that's not in the default position
    8.times do |row|
      8.times do |col|
        board[row][col] = (row * col) % 6 == 0 ? white_pawn : black_pawn
      end
    end

    it "returns true when the selected piece has the player's color" do
      8.times do |row|
        8.times do |col|
          if (row * col) % 6 == 0
            expect(board.belong_to_player?([row, col], :white)).to eql(true)
          else
            expect(board.belong_to_player?([row, col], :black)).to eql(true)
          end
        end
      end
    end

    it "returns false when the selected piece doesn't have the player's " +
        "color" do
      8.times do |row|
        8.times do |col|
          if (row * col) % 6 == 0
            expect(board.belong_to_player?([row, col],
              :black)).to eql(false)
          else
            expect(board.belong_to_player?([row, col],
              :white)).to eql(false)
          end
        end
      end
    end
  end

  describe "#same_color?" do
    board = Board.new
    white_pawn = Pawn.new(:white)
    black_pawn = Pawn.new(:black)
    # Set the board to have pieces that's not in the default position
    8.times do |row|
      8.times do |col|
        board[row][col] = (row * col) % 6 == 0 ? white_pawn : black_pawn
      end
    end

    it "returns true when both pieces have the same color" do
      8.times do |row|
        8.times do |col|
          8.times do |i|
            8.times do |j|
              if (row * col) % 6 == 0 && (i * j) % 6 == 0
                expect(board.same_color?([row, col], [i, j])).to eql(true)
              end
              if (row * col) % 6 != 0 && (i * j) % 6 != 0
                expect(board.same_color?([row, col], [i, j])).to eql(true)
              end
            end
          end
        end
      end
    end

    it "returns false when both pieces have the different color" do
      8.times do |row|
        8.times do |col|
          8.times do |i|
            8.times do |j|
              if (row * col) % 6 == 0 && (i * j) % 6 != 0
                expect(board.same_color?([row, col], [i, j])).to eql(false)
              end
              if (row * col) % 6 != 0 && (i * j) % 6 == 0
                expect(board.same_color?([row, col], [i, j])).to eql(false)
              end
            end
          end
        end
      end
    end
  end
end