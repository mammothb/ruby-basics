# frozen_string_literal: true

require './lib/board.rb'
require './lib/pieces/pieces.rb'

RSpec.describe King do
  def all_board_pos
    (0..7).to_a.repeated_permutation(2).to_a
  end

  describe '#impossible_move?' do
    def moves(row, col)
      [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [-1, 1], [-1, -1],
       [1, -1]].select { |i, j| Board.in_bounds?(row + i, col + j) }
        .map { |i, j| [row + i, col + j] }
    end

    it 'returns false when destination is reachable' do
      all_board_pos.each do |row, col|
        moves(row, col).each do |pos|
          piece = King.new(:w, [row, col])
          expect(piece.impossible_move?([], pos)).to eql(false)
        end
      end
    end

    it 'returns true when destination cannot not be reached' do
      all_board_pos.each do |row, col|
        piece = King.new(:w, [row, col])
        (all_board_pos - moves(row, col) - [row, col]).each do |pos|
          expect(piece.impossible_move?([], pos)).to eql(true)
        end
      end
    end
  end

  describe '#obstructed?' do
    board = Board.new

    it 'returns false when destination is empty' do
      8.times do |row|
        8.times do |col|
          piece = King.new(:w, [row, col])
          8.times do |i|
            8.times do |j|
              if board[i][j] == ' ' || board[i][j].color == :b
                expect(piece.obstructed?(board, [i, j])).to eql(false)
              end
            end
          end
        end
      end
    end

    it 'returns false when destination is occupied by ally' do
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
