class Board
  attr_accessor :code
  attr_reader :past_guess

  def self.check(code, guess)
    tmp_code = []
    tmp_guess = []
    result = ""
    code.zip(guess) do |c, g|
      if c == g
        result += "B"
      else
        tmp_code.push(c)
        tmp_guess.push(g)
      end
    end
    result += "W" * (tmp_code & tmp_guess).length
  end

  def initialize
    @code = Array.new(4) { rand(1..6) }
    @past_guess = []
  end

  def add_guess(guess)
    @past_guess.push([guess, self.class.check(@code, guess)])
  end

  def guessed_code?
    !@past_guess.empty? && @past_guess[-1][1] == "BBBB"
  end

  def to_s
    str = Array.new(@past_guess.length) do |i|
      "#{@past_guess[i][0].join} | #{@past_guess[i][1]}"
    end
    str.push("").join("\n-----+-----\n")
  end
end

class Computer
  ALL_OUTCOMES = (Array.new(5) do |i|
    ["B", "W"].repeated_combination(i).to_a.map(&:join)
  end.flatten! - ["BBBW"]).freeze

  attr_reader :guess

  def initialize
    @guess = [1, 1, 2, 2]
    @all_codes = (1..6).to_a.repeated_permutation(4).to_a
    @candidates = Marshal.load(Marshal.dump(@all_codes))
  end

  def compute_max_elimination(guess)
    eliminations = Hash.new(0)
    @candidates.each { |c| eliminations[Board.check(c, guess)] += 1 }
    eliminations.values.max
  end

  def compute_next_guess(result)
    if result.nil?
      return
    end
    @all_codes -= [result[0]]
    @candidates -= [result[0]]
    @candidates.select! { |code| match_outcome?(code, result[0], result[1]) }

    max_eliminations = {}
    @all_codes.each do |guess|
      eliminations = Hash.new(0)
      @candidates.each do |code|
        eliminations[Board.check(code, guess)] += 1
      end
      max_eliminations[guess] = eliminations.values.max
    end
    min_elimination = max_eliminations.values.min
    guess_candidates = max_eliminations.select do |k, v|
      v == min_elimination
    end.keys
    guess_candidates.each do |guess|
      if @candidates.include?(guess)
        @guess = guess
        return
      end
    end
    guess_candidates.each do |guess|
      if @all_codes.include?(guess)
        @guess = guess
        return
      end
    end
  end

  def match_outcome?(code, guess, outcome)
    Board.check(code, guess) == outcome
  end
end

class Mastermind
  MAX_NUM_ATTEMPT = { easy: 12, normal: 10, hard: 8 }
  def initialize
    @board = Board.new
    @num_attempt = 0
    @creator_mode = false
  end

  def choose_difficulty(difficulty)
    case difficulty.downcase
    when "easy"
      @difficulty = :easy
    when "normal"
      @difficulty = :normal
    when "hard"
      @difficulty = :hard
    else
      puts "Choose only 'easy', 'normal', or 'hard'."
    end
  end

  def create_code
    puts "Create a code for the computer to guess"
    @board.code = get_guess
    @creator_mode = true
    @computer = Computer.new
  end

  def get_guess
    guess = gets.chomp
    until valid_guess?(guess)
      guess = gets.chomp
    end
    guess.split("").map(&:to_i)
  end

  def play
    until game_ended?
      puts "Key: (W) - Right color, wrong position"
      puts "     (B) - Right color, right position"
      if @creator_mode
        @computer.compute_next_guess(@board.past_guess[-1])
        guess = @computer.guess
        puts "Guess (#{remaining_guess} guesses left): #{guess}"
      else
        print "Guess a code (#{remaining_guess} guesses left): "
        guess = get_guess
      end
      
      @board.add_guess(guess)
      puts @board
      @num_attempt += 1
    end

    if @board.guessed_code?
      puts "You won!"
    else
      puts "You lost! The code was #{@board.code.join}"
    end
  end

  def remaining_guess
    MAX_NUM_ATTEMPT[@difficulty] - @num_attempt
  end

  def valid_guess?(guess)
    if (guess.length <=> 4) != 0
      print "Enter 4 digits only: "
      false
    elsif !(Integer(guess) rescue false)
      print "Enter numbers only: "
      false
    elsif !Integer(guess).between?(1111, 6666)
      print "Enter between 1111..6666 only: "
      false
    else
      true
    end
  end

  def game_ended?
    remaining_guess == 0 || @board.guessed_code?
  end
end

game = Mastermind.new
game.choose_difficulty("easy")
game.create_code

game.play
# p game
