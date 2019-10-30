# frozen_string_literal: true

require 'fileutils'
require 'yaml'

require_relative 'board.rb'
require_relative 'computer.rb'
require_relative 'player.rb'

# Main class to control the flow of a chess game
class Chess
  DATA_DIR = File.join(File.dirname(__dir__), 'data')
  PERMITTED_CLASSES = [Bishop, Board, BoardValues, Chess, Computer, King,
                       Knight, Pawn, Player, Queen, Rook, Symbol].freeze

  attr_accessor :board, :players
  attr_writer :current_player

  def initialize(player_one, player_two)
    @players = [player_one, player_two]
    @board = Board.new
    @board.game = self
    @current_player = 0
    FileUtils.mkdir_p(DATA_DIR)
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

  def start
    puts 'Would you like to:'
    puts '1. Start new game'
    puts '2. Load game'
    choice = gets.chomp
    until /^\d$/ =~ choice && choice.to_i.between?(1, 2)
      print 'Please choose only between 1 and 2: '
      choice = gets.chomp
    end
    case choice.to_i
    when 1
      play
    when 2
      load_game
      play
    end
  end

  def request_pawn_promotion
    current_player.promote_pawn
  end

  private

  def switch_player
    @current_player = (@current_player + 1) % 2
  end

  def play
    puts 'Flip a coin to decide who starts first' unless prepared?
    until game_over?
      turn_message
      move = request_player_move
      if save_game?(move)
        save_game
        break
      end
      board.execute_move(move)
      switch_player
    end
    game_over_message unless save_game?(move)
  end

  def request_player_move
    move = convert_to_coordinate(current_player.make_move)
    until save_game?(move) || board.valid_move?(move, current_player.color)
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
    puts board
    if board.checked?(current_player.color)
      switch_player
      puts "#{current_player.name} is the winner!"
    else
      puts 'Stalemate'
    end
  end

  def save_game
    print 'Enter a name for the save file: '
    filename = gets.chomp
    until valid_filename?(filename)
      print 'Enter a valid filename: '
      filename = gets.chomp
    end
    File.open(File.join(DATA_DIR, filename), 'w') do |file|
      file.write(YAML.dump(self))
    end
    puts 'Game saved!'
  end

  def load_game
    Dir[File.join(DATA_DIR, '*')].each do |filename|
      puts File.basename(filename)
    end
    print 'Which save file would you like to load?: '
    filename = gets.chomp
    until File.exist?(File.join(DATA_DIR, filename))
      print 'Enter a valid filename: '
      filename = gets.chomp
    end
    File.open(File.join(DATA_DIR, filename), 'r') do |object|
      tmp = YAML.safe_load(object, permitted_classes: PERMITTED_CLASSES,
                                   aliases: true)
      @players = tmp.players
      @board = tmp.board
      @board.game = tmp
      @current_player = @players.index(tmp.current_player)
    end
  end

  def prepared?
    @players.all?(&:color)
  end

  def game_over?
    !board.escape_checked?(current_player.color)
  end

  def save_game?(move)
    move == 'save'
  end

  def valid_filename?(filename)
    begin
      File.open(File.join(DATA_DIR, filename), 'a') {}
      true
    rescue Errno::ENOENT
      false
    end
  end

  # Convert move string [col, row] to matrix coordinates [row, col],
  # e.g., a2 c5 => { from: [1, 0], to: [4, 2] }
  def convert_to_coordinate(move_string)
    return move_string if move_string == 'save'

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
  # p2 = Player.new('Bob')
  p2 = Computer.new('Bob')

  game = Chess.new(p1, p2)
  p2.board = game.board

  game.flip_coin
  game.start
end
