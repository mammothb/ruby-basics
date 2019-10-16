require_relative "board.rb"
require_relative "player.rb"

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
    current_player.color = "white"
    switch_player
    current_player.color = "black"
    switch_player
  end

  def play
    unless prepared?
      puts "Flip a coin to decide who starts first"
    end

    switch_player
    10.times do
      switch_player
      puts board
      print "#{current_player.name}'s turn (#{current_player.icon} ): "
      move = convert_to_coordinate(current_player.get_move)
      until board.valid_move?(move, current_player.color)
        move = convert_to_coordinate(current_player.get_move)
      end
      p move
    end
  end

  def prepared?
    @players.all? { |p| p.color }
  end

  private
    def convert_to_coordinate(move_string)
      move_array = move_string.split(" ")
      [:from, :to].zip(move_array).map do |k, pos|
        [k, [("a".."h").find_index(pos[0]), ("1".."8").find_index(pos[1])]]
      end.to_h
    end
end

if __FILE__ == $0
  p1 = Player.new("Alice")
  p2 = Player.new("Bob")

  game = Chess.new(p1, p2)
  game.flip_coin
  game.play
  puts game.board
  
  # PIECES = {
  #   KING: { W: "\u2654", B: "\u265A" },
  #   QUEEN: { W: "\u2655", B: "\u265B" },
  #   ROOK: { W: "\u2656", B: "\u265C" },
  #   BISHOP: { W: "\u2657", B: "\u265D" },
  #   KNIGHT: { W: "\u2658", B: "\u265E" },
  #   PAWN: { W: "\u2659", B: "\u265F" }
  # }

  # PIECES_BY_COLOR = {
  #   W: {
  #     KING: "\u2654",
  #     QUEEN: "\u2655",
  #     ROOK: "\u2656",
  #     BISHOP: "\u2657",
  #     KNIGHT: "\u2658",
  #     PAWN: "\u2659"
  #   },
  #   B: {
  #     KING: "\u265A",
  #     QUEEN: "\u265B",
  #     ROOK: "\u265C",
  #     BISHOP: "\u265D",
  #     KNIGHT: "\u265E",
  #     PAWN: "\u265F"
  #   }
  # }

  # def piece_color(game_piece)
  #   color = PIECES_BY_COLOR.find { |k, h| h.key(game_piece) }
  #   color[0] unless color.nil?
  # end
end