# frozen_string_literal: true

require './lib/board_values.rb'
require './lib/pieces/pieces.rb'

RSpec.describe Pawn do
  def all_board_pos
    (0..7).to_a.repeated_permutation(2).to_a
  end

  def moves(row, col, is_on_baseline, is_capturing, is_white)
    if is_capturing
      directions = [[1, 1], [1, -1]]
    else
      directions = [[1, 0]]
      directions += [[2, 0]] if is_on_baseline
    end
    directions.map! { |x| x.map(&:-@) } unless is_white
    directions.select do |i, j|
      (row + i).between?(0, 7) && (col + j).between?(0, 7)
    end.map { |i, j| [row + i, col + j] }
  end

  describe '#impossible_move?' do
    it 'returns false when destination is reachable' do
      empty_values = BoardValues.new(8, ' ')
      all_board_pos.each do |row, col|
        white_piece = Pawn.new(:w, [row, col])
        black_piece = Pawn.new(:b, [row, col])
        moves(row, col, row == 1, false, true).each do |pos|
          expect(white_piece.impossible_move?(empty_values,
                                              pos)).to eql(false)
        end
        moves(row, col, row == 6, false, false).each do |pos|
          expect(black_piece.impossible_move?(empty_values,
                                              pos)).to eql(false)
        end
        moves(row, col, row == 1, true, true).each do |pos|
          board_values = BoardValues.new(8, ' ')
          board_values[pos] = Pawn.new(:b, pos)
          expect(white_piece.impossible_move?(board_values,
                                              pos)).to eql(false)
        end
        moves(row, col, row == 1, true, false).each do |pos|
          board_values = BoardValues.new(8, ' ')
          board_values[pos] = Pawn.new(:w, pos)
          expect(black_piece.impossible_move?(board_values,
                                              pos)).to eql(false)
        end
      end
    end

    it 'returns true when destination cannot not be reached' do
      all_moves = (0..7).to_a.repeated_permutation(2).to_a
      empty_values = BoardValues.new(8, ' ')
      all_board_pos.each do |row, col|
        piece_pos = [row, col]
        white_piece = Pawn.new(:w, piece_pos)
        black_piece = Pawn.new(:b, piece_pos)
        (all_moves - moves(row, col, row == 1, false, true) -
            piece_pos).each do |pos|
          expect(white_piece.impossible_move?(empty_values, pos)).to eql(true)
        end
        (all_moves - moves(row, col, row == 6, false, false) -
            piece_pos).each do |pos|
          expect(black_piece.impossible_move?(empty_values, pos)).to eql(true)
        end
        (all_moves - moves(row, col, row == 1, true, true) -
            piece_pos).each do |pos|
          board_values = BoardValues.new(8, ' ')
          board_values[pos] = Pawn.new(:b, pos)
          expect(white_piece.impossible_move?(board_values,
                                              pos)).to eql(true)
        end
        (all_moves - moves(row, col, row == 6, true, false) -
            piece_pos).each do |pos|
          board_values = BoardValues.new(8, ' ')
          board_values[pos] = Pawn.new(:w, pos)
          expect(black_piece.impossible_move?(board_values,
                                              pos)).to eql(true)
        end
      end
    end
  end

  describe '#obstructed?' do
    board = Board.new
    pawn = Pawn.new(:w)

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    8.times do |j|
      if j.even?
        board[2][j] = pawn
      else
        board[5][j] = pawn
      end
    end

    it "returns true when there's another piece in the way" do
      8.times do |j|
        white_pawn = Pawn.new(:w, [1, j])
        black_pawn = Pawn.new(:b, [6, j])
        if j.even?
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
        if j.even?
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

  describe '#perform_en_passant?' do
    board = Board.new
    black_pawn = Pawn.new(:b, [3, 3])
    white_pawn = Pawn.new(:w, [4, 3])

    8.times { |i| 8.times { |j| board[i][j] = Board::EMPTY } }
    board.place(black_pawn)
    board.place(white_pawn)

    it 'returns true when a pawn performed a two-square opening' do
      pawn = Pawn.new(:w, [1, 4])
      board.place(pawn)
      board.execute_move(from: pawn.pos, to: [pawn.row + 2, pawn.col])
      expect(black_pawn.perform_en_passant?(board[black_pawn.row][pawn.col]))
        .to eql(true)

      pawn = Pawn.new(:b, [6, 4])
      board.place(pawn)
      board.execute_move(from: pawn.pos, to: [pawn.row - 2, pawn.col])
      expect(white_pawn.perform_en_passant?(board[white_pawn.row][pawn.col]))
        .to eql(true)
    end

    it 'returns false when a pawn advanced only one square' do
      pawn = Pawn.new(:w, [2, 4])
      board.place(pawn)
      board.execute_move(from: pawn.pos, to: [pawn.row + 2, pawn.col])
      expect(black_pawn.perform_en_passant?(board[black_pawn.row][pawn.col]))
        .to eql(false)

      pawn = Pawn.new(:b, [5, 4])
      board.place(pawn)
      board.execute_move(from: pawn.pos, to: [pawn.row - 2, pawn.col])
      expect(white_pawn.perform_en_passant?(board[white_pawn.row][pawn.col]))
        .to eql(false)
    end
  end
end
