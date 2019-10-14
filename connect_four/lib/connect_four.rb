class Player
  attr_reader :name
  attr_accessor :symbol

  def initialize(name)
    @name = name
    @symbol = nil
  end
end

class Node
  attr_reader :row, :col
  attr_accessor :value

  def initialize(row, col)
    @row = row
    @col = col
    @value = " "
  end
end

class Board
  NUM_ROW = 6.freeze
  NUM_COL = 7.freeze
  DIRECTIONS = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1],
    [-1, 0], [1, -1]].freeze

  attr_accessor :values

  def initialize
    @values = Array.new(NUM_ROW) do |i|
      Array.new(NUM_COL) { |j| Node.new(i, j) }
    end
  end

  def [](index)
    values[index]
  end

  def length
    values.length
  end

  def value(i, j)
    values[i][j].value
  end

  def is_full?
    values.all? { |row| row.all? { |node| node.value != " " } }
  end

  def column_full?(col)
    values.all? { |row| row[col].value != " " }
  end

  def in_bound?(row, col)
    row.between?(0, NUM_ROW - 1) && col.between?(0, NUM_COL - 1)
  end

  def has_win_condition?
    DIRECTIONS.each do |row, col|
      ([0, -3 * row].max...[NUM_ROW, NUM_ROW - 3 * row].min).each do |i|
        ([0, -3 * col].max...[NUM_COL, NUM_COL - 3 * col].min).any? do |j|
          next unless value(i, j) != " "
          if (0..3).map { |n| value(i + n * row, j + n * col) }.uniq.count == 1
            return true
          end
        end
      end
    end 
    false
  end

  def winning_symbol
    DIRECTIONS.each do |row, col|
      ([0, -3 * row].max...[NUM_ROW, NUM_ROW - 3 * row].min).each do |i|
        ([0, -3 * col].max...[NUM_COL, NUM_COL - 3 * col].min).any? do |j|
          next unless value(i, j) != " "
          if (0..3).map { |n| value(i + n * row, j + n * col) }.uniq.count == 1
            return value(i, j)
          end
        end
      end
    end
  end

  def add_game_piece(col, symbol)
    values.find { |row| row[col].value == " " }[col].value = symbol
  end

  def to_s
    result = ""
    values.reverse.each do |row|
      result += "|#{row.map { |node| " #{node.value} |" }.join("")}\n"
    end
    result
  end
end

class ConnectFour
  attr_accessor :board

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
    current_player.symbol = "X"
    switch_player
    current_player.symbol = "O"
    switch_player
  end

  def get_column
    column = Integer(gets) rescue false
    until column && valid_move?(column - 1)
      if column && valid_move?(column - 1)
        puts "Column full"
      else
        puts "Enter a valid integer"
      end
      column = Integer(gets) rescue false
    end
    column
  end

  def winner
    if board.has_win_condition?
      winning_player = @players.find do |player|
        player.symbol == board.winning_symbol
      end
      "#{winning_player.name} is the winner!"
    elsif board.is_full?
      "It's a draw."
    end
  end
  
  def play
    unless prepared?
      puts "Flip a coin to decide who starts first"
      return
    end

    switch_player
    until game_over?
      switch_player
      puts board
      print "#{current_player.name}'s turn (#{current_player.symbol}): "

      column = get_column
      board.add_game_piece(column - 1, current_player.symbol)
    end

    puts board
    puts winner
  end

  def prepared?
    @players.all? { |p| p.symbol }
  end

  def game_over?
    board.is_full? || board.has_win_condition?
  end

  def valid_move?(col)
    board.in_bound?(0, col) && !board.column_full?(col)
  end
end

if __FILE__ == $0
  p1 = Player.new("Alice")
  p2 = Player.new("Bob")

  game = ConnectFour.new(p1, p2)
  game.flip_coin
  game.play
end
