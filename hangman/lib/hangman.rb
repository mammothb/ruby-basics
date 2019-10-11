require "yaml"

class Hangman
  MAX_MISSES = 6.freeze
  attr_reader :display, :word, :guesses, :num_misses

  def initialize(dictionary_path)
    unless File.exist?(dictionary_path)
      raise "#{dictionary_path} does not exist."
    end
    @dictionary_path = dictionary_path
    @word = get_random_word
    @display = Array.new(@word.length, "_")
    @guesses = { all: [], miss: [] }
    @num_misses = 0
  end

  def start
    print "Enter a filename to load a saved game: "
    load_game
    until game_end?
      guess = get_guess
      return if guess == "save"
      @num_misses += 1 unless check_guess(guess)
    end
    print "Press 'y' to play again: "
    if gets.chomp.downcase == "y"
      restart
    end
  end

  def restart
    initialize(@dictionary_path)
    start
  end

  private
    def get_random_word
      File.foreach(@dictionary_path).select do |line|
        # 7 to 14 characters instead to account for /r/n line ending
        line.length.between?(7, 14)
      end.map(&:rstrip).map(&:downcase).sample
    end

    def print_display
      head = @num_misses > 0 ? "O" : " "
      torso = @num_misses > 3 ? "/|\\" :
          @num_misses > 2 ? "/| " :
          @num_misses > 1 ? " | " : "   "
      legs = @num_misses > 5 ? "/ \\" :
          @num_misses > 4 ? "/  " : "   "
      puts " +----+ "
      puts " |    | "
      puts " #{head}    | "
      puts "#{torso}   | "
      puts "#{legs}   | "
      puts " -----+-"
      puts "#{@display.join(" ")}"
      puts "Misses: #{@guesses[:miss].join(", ")}"
    end

    def get_guess
      print "Guess: "
      while guess = gets.chomp
        if guess =~ /[^[:alpha:]]/
          print "Only alphabets (a-z) are allowed: "
        elsif guess.downcase == "save"
          print "Enter a name for the save file: "
          save_game
          puts "Saved!"
          break
        elsif guess.length != 1
          print "Enter a letter: "
        elsif @guesses[:all].include?(guess.downcase)
          print "Already guessed this, choose a new letter: "
        else
          break
        end
      end
      guess.downcase
    end

    def check_guess(guess)
      @guesses[:all].push(guess)
      if @word.include?(guess)
        @word.length.times { |i| @display[i] = guess if @word[i] == guess }
        return true
      end
      @guesses[:miss].push(guess)
      false
    end

    def game_end?
      print_display
      if !@display.include?("_")
        puts "You won!"
        return true
      elsif @num_misses == MAX_MISSES
        puts "You lost, the word is #{@word}."
        return true
      end
      false
    end

    def valid_filename?(filename)
      begin
        File.open(filename, "a") {}
        true
      rescue
        false
      end
    end

    def save_game
      filename = gets.chomp
      until valid_filename?(filename)
        print "Enter a valid filename: "
        filename = gets.chomp
      end
      File.open(filename, "w") { |file| file.write(YAML::dump(self)) }
    end

    def load_game
      filename = gets.chomp
      if File.exist?(filename)
        File.open(filename, "r") do |object|
          tmp = YAML::load(object)
          @display = tmp.display
          @word = tmp.word
          @guesses = tmp.guesses
          @num_misses = tmp.num_misses
        end
      elsif filename.rstrip == ""
        puts "Skipped loading, starting new game..."
      else
        puts "Save file not found! Starting new game..."
      end
    end
end

dictionary_path = File.expand_path("../5desk.txt", __dir__)

game = Hangman.new(dictionary_path)
game.start
