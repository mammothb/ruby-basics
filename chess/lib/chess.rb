# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'player.rb'

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

  def switch_player
    @current_player = (@current_player + 1) % 2
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

    until game_over? do
      puts board
      puts 'Your king is in check' if board.checked?(current_player.color)
      print "#{current_player.name}'s turn (#{current_player.icon} ): "
      move = convert_to_coordinate(current_player.make_move)
      until board.valid_move?(move, current_player.color)
        move = convert_to_coordinate(current_player.make_move)
      end
      board.execute_move(move)
      switch_player
    end

    switch_player
    puts board
    puts "#{current_player.name} is the winner!"
  end

  def prepared?
    # @players.all? { |player| player.color }
    @players.all?(&:color)
  end

  def game_over?
    board.checked?(current_player.color) &&
      !board.escape_checked?(current_player.color)
  end

  private

  # Convert move string [col, row] to matrix coordinates [row, col],
  # e.g., a2 c5 => { from: [1, 0], to: [4, 2] }
  def convert_to_coordinate(move_string)
    move_array = move_string.split(' ')
    %i[from to].zip(move_array).map do |k, pos|
      [k, [('1'..'8').find_index(pos[1]), ('a'..'h').find_index(pos[0])]]
    end.to_h
  end
end

if $PROGRAM_NAME == __FILE__
  p1 = Player.new('Alice')
  p2 = Player.new('Bob')

  game = Chess.new(p1, p2)
  pawn = Pawn.new(:b, [3, 2])
  game.board.place(pawn)

  game.flip_coin
  game.play
  # puts game.board

  # queen = Queen.new(:w, [4, 5])
  # p queen.all_possible_moves

  # king = King.new(:w, [4, 5])
  # p king.all_possible_moves
end
