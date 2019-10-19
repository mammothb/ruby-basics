# frozen_string_literal: true

require './lib/board.rb'
require './lib/pieces/pieces.rb'

RSpec.describe Board do
  describe '#include_nil?' do
    board = Board.new

    it 'returns true when given a hash containing nil in its values' do
      moves = [{ from: [1, 2], to: [3, nil] },
               { from: [1, 2], to: [nil, 4] },
               { from: [1, nil], to: [3, 4] },
               { from: [nil, 2], to: [3, 4] },
               { from: [1, 2], to: [nil, nil] },
               { from: [nil, nil], to: [nil, 4] }]
      moves.each do |move|
        expect(board.include_nil?(move)).to eql(true)
      end
    end

    it "returns false when given a hash doesn't contain nil values" do
      moves = [{ from: [1, 2], to: [3, 4] },
               { from: [11, 12], to: [13, 14] }]
      moves.each do |move|
        expect(board.include_nil?(move)).to eql(false)
      end
    end
  end

  describe '::in_bounds?' do
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
      w: {
        king: King.new(:w),
        queen: Queen.new(:w),
        rook: Rook.new(:w),
        bishop: Bishop.new(:w),
        knight: Knight.new(:w),
        pawn: Pawn.new(:w)
      },
      b: {
        king: King.new(:b),
        queen: Queen.new(:b),
        rook: Rook.new(:b),
        bishop: Bishop.new(:b),
        knight: Knight.new(:b),
        pawn: Pawn.new(:b)
      }
    }

    board = Board.new

    it "returns the proper node when given [row, col]" do
      expect(board[[0, 0]].symbol).to eql(pieces[:w][:rook].symbol)
      expect(board[[0, 7]].symbol).to eql(pieces[:w][:rook].symbol)
      expect(board[[0, 1]].symbol).to eql(pieces[:w][:knight].symbol)
      expect(board[[0, 6]].symbol).to eql(pieces[:w][:knight].symbol)
      expect(board[[0, 2]].symbol).to eql(pieces[:w][:bishop].symbol)
      expect(board[[0, 5]].symbol).to eql(pieces[:w][:bishop].symbol)
      expect(board[[0, 3]].symbol).to eql(pieces[:w][:queen].symbol)
      expect(board[[0, 4]].symbol).to eql(pieces[:w][:king].symbol)

      expect(board[[7, 0]].symbol).to eql(pieces[:b][:rook].symbol)
      expect(board[[7, 7]].symbol).to eql(pieces[:b][:rook].symbol)
      expect(board[[7, 1]].symbol).to eql(pieces[:b][:knight].symbol)
      expect(board[[7, 6]].symbol).to eql(pieces[:b][:knight].symbol)
      expect(board[[7, 2]].symbol).to eql(pieces[:b][:bishop].symbol)
      expect(board[[7, 5]].symbol).to eql(pieces[:b][:bishop].symbol)
      expect(board[[7, 3]].symbol).to eql(pieces[:b][:queen].symbol)
      expect(board[[7, 4]].symbol).to eql(pieces[:b][:king].symbol)

      8.times do |i|
        expect(board[[1, i]].symbol).to eql(pieces[:w][:pawn].symbol)
        expect(board[[6, i]].symbol).to eql(pieces[:b][:pawn].symbol)
      end
    end

    it "returns the proper node when given [row]" do
      expect(board[0][0].symbol).to eql(pieces[:w][:rook].symbol)
      expect(board[0][7].symbol).to eql(pieces[:w][:rook].symbol)
      expect(board[0][1].symbol).to eql(pieces[:w][:knight].symbol)
      expect(board[0][6].symbol).to eql(pieces[:w][:knight].symbol)
      expect(board[0][2].symbol).to eql(pieces[:w][:bishop].symbol)
      expect(board[0][5].symbol).to eql(pieces[:w][:bishop].symbol)
      expect(board[0][3].symbol).to eql(pieces[:w][:queen].symbol)
      expect(board[0][4].symbol).to eql(pieces[:w][:king].symbol)

      expect(board[7][0].symbol).to eql(pieces[:b][:rook].symbol)
      expect(board[7][7].symbol).to eql(pieces[:b][:rook].symbol)
      expect(board[7][1].symbol).to eql(pieces[:b][:knight].symbol)
      expect(board[7][6].symbol).to eql(pieces[:b][:knight].symbol)
      expect(board[7][2].symbol).to eql(pieces[:b][:bishop].symbol)
      expect(board[7][5].symbol).to eql(pieces[:b][:bishop].symbol)
      expect(board[7][3].symbol).to eql(pieces[:b][:queen].symbol)
      expect(board[7][4].symbol).to eql(pieces[:b][:king].symbol)

      8.times do |i|
        expect(board[1][i].symbol).to eql(pieces[:w][:pawn].symbol)
        expect(board[6][i].symbol).to eql(pieces[:b][:pawn].symbol)
      end
    end
  end

  describe "#empty_selection?" do
    board = Board.new
    pawn = Pawn.new(:w)
    # Set the board to have pieces that's not in the default position
    8.times do |row|
      8.times do |col|
        board[row][col] = (row * col) % 6 == 0 ? pawn : Board::EMPTY
      end
    end

    it "returns true when the position doesn't contain a Piece" do
      8.times do |row|
        8.times do |col|
          unless (row * col) % 6 == 0
            expect(board.empty_selection?([row, col])).to eql(true)
          end
        end
      end
    end

    it "returns false when the position contains a Piece" do
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
    white_pawn = Pawn.new(:w)
    black_pawn = Pawn.new(:b)
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
            expect(board.belong_to_player?([row, col], :w)).to eql(true)
          else
            expect(board.belong_to_player?([row, col], :b)).to eql(true)
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
              :b)).to eql(false)
          else
            expect(board.belong_to_player?([row, col],
              :w)).to eql(false)
          end
        end
      end
    end
  end

  describe "#same_color?" do
    board = Board.new
    white_pawn = Pawn.new(:w)
    black_pawn = Pawn.new(:b)
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
