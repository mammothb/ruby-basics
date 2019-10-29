# frozen_string_literal: true
require_relative "player.rb"

class Computer < Player
  attr_writer :board

  def initialize(name)
    super
    @board = nil
  end

  def make_move
    all_moves = []
    @board.player_pieces(color).each do |piece|
      piece.all_possible_moves(@board).each do |move|
        all_moves << { from: piece.pos, to: move }
      end
    end
    convert_to_chess_notation(all_moves.sample)
  end

  private

  def convert_to_chess_notation(move)
    ranks = (1..8).to_a
    files = ('a'..'h').to_a
    "#{files[move[:from][1]]}#{ranks[move[:from][0]]} " \
    "#{files[move[:to][1]]}#{ranks[move[:to][0]]}"
  end
end