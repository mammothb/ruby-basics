# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'player.rb'

# Main class to control the flow of a chess game
class Chess
  attr_reader :board

  def initialize(player_one, player_two)
    @players = [player_one, player_two]
    @board = Board.new
    @current_player = 0
  end

  def current_player
    @players[@current_player]
  end

  def flip_coin
    @current_player = rand(2).floor
    puts "#{current_player.name} goes first."
    current_player.color = :w
    switch_player
    current_player.color = :b
    switch_player
  end

  def play
    puts 'Flip a coin to decide who starts first' unless prepared?
    until game_over?
      turn_message
      move = request_player_move
      board.execute_move(move)
      switch_player
    end
    game_over_message
  end

  private

  def switch_player
    @current_player = (@current_player + 1) % 2
  end

  def request_player_move
    move = convert_to_coordinate(current_player.make_move)
    until board.valid_move?(move, current_player.color)
      move = convert_to_coordinate(current_player.make_move)
    end
    move
  end

  def turn_message
    puts board
    puts 'Your king is in check' if board.checked?(current_player.color)
    print "#{current_player.name}'s turn (#{current_player.icon} ): "
  end

  def game_over_message
    switch_player
    puts board
    puts "#{current_player.name} is the winner!"
  end

  def prepared?
    @players.all?(&:color)
  end

  def game_over?
    board.checked?(current_player.color) &&
      !board.escape_checked?(current_player.color)
  end

  # Convert move string [col, row] to matrix coordinates [row, col],
  # e.g., a2 c5 => { from: [1, 0], to: [4, 2] }
  def convert_to_coordinate(move_string)
    move_array = move_string.split(' ')
    return convert_castling(move_string.size == 3) if move_array.size == 1

    %i[from to].zip(move_array).map do |k, pos|
      [k, [('1'..'8').find_index(pos[1]), ('a'..'h').find_index(pos[0])]]
    end.to_h
  end

  def convert_castling(kingside)
    row = current_player.color == :w ? 0 : 7
    {
      king: { from: [row, 4], to: [row, kingside ? 6 : 1] },
      rook: { from: [row, kingside ? 7 : 0], to: [row, kingside ? 5 : 2] }
    }
  end
end

if $PROGRAM_NAME == __FILE__
  p1 = Player.new('Alice')
  p2 = Player.new('Bob')

  game = Chess.new(p1, p2)

  game.flip_coin
  game.play
end
