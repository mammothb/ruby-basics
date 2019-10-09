class Board
  attr_accessor :values

  def initialize
    @values = Array.new(9, " ")
  end

  def has_win_condition?(conditions)
    conditions.any? do |indices|
      values.values_at(*indices).uniq.count == 1 &&
        values.values_at(*indices).uniq[0] != " "
    end
  end

  def is_full?
    values.all? { |x| x != " " }
  end

  def is_open?(index)
    values[index - 1] == " "
  end

  def to_s
    Array.new(3) { |i| " #{values[i * 3..i * 3 + 2].join(' | ')}" }
      .join("\n---+---+---\n")
  end
end

class Player
  attr_reader :name
  attr_accessor :symbol

  def initialize(name)
    @name = name
    @symbol = nil
  end
end

class TicTacToe
  WIN_CONDITIONS = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7],
                    [2, 5, 8], [0, 4, 8], [2, 4, 6]].freeze

  attr_accessor :board

  def initialize(player_one, player_two)
    @board = Board.new
    @players = [player_one, player_two]
    @current_player = 0
  end

  def switch_player
    @current_player = (@current_player + 1) % 2
  end

  def current_player
    @players[@current_player]
  end

  def flip_coin
    @current_player = rand(2).floor
    puts "#{current_player.name} goes first."
    current_player.symbol = "X"
    switch_player
    current_player.symbol = "O"
    switch_player
  end

  def get_index
    index = Integer(gets) rescue false
    until index && valid_index?(index) && board.is_open?(index)
      if index && valid_index?(index)
        puts "Position already occupied, choose another position"
      else
        puts "Enter a valid integer"
      end
      index = Integer(gets) rescue false
    end
    index
  end

  def winner
    if board.has_win_condition?(WIN_CONDITIONS)
      "#{current_player.name} is the winner!"
    else
      "It's a draw."
    end
  end

  def play
    unless prepared?
      puts "Flip a coin to decide who starts first"
      return
    end

    switch_player
    until game_ended?
      switch_player
      puts board
      print "#{current_player.name}'s turn (#{current_player.symbol}): "

      index = get_index - 1
      board.values[index] = current_player.symbol
    end
    
    puts winner
  end

  def prepared?
    @players.all? { |p| p.symbol }
  end

  def valid_index?(index)
    index.between?(1, 9)
  end

  def game_ended?
    board.is_full? || board.has_win_condition?(WIN_CONDITIONS)
  end
end

p1 = Player.new("Alice")
p2 = Player.new("Bob")

game = TicTacToe.new(p1, p2)
game.flip_coin
game.play
