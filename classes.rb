# birthDate = "1999-01-19"
# birthDate = Time.mktime(*(birthDate.split("-").map(&:to_i)))
# ((Time.new - birthDate) / 60 / 60 / 24 / 365).floor.times {
#   puts "SPANK"
# }

# class Dice
#   def initialize
#     roll
#   end

#   def roll
#     @numberShowing = 1 + rand(6)
#   end

#   def cheat number
#     if number >= 1 && number <= 6
#       @numberShowing = number
#     end
#   end

#   def showing
#     @numberShowing
#   end
# end

# die = Dice.new
# die.roll
# puts die.showing
# die.cheat 2
# puts die.showing
# die.cheat 0
# puts die.showing
# die.cheat 7
# puts die.showing

class OrangeTree
  def initialize
    @age = 0
    @height = 1
    @orangeCount = 0
  end

  def height
    @height
  end

  def countTheOrange
    @orangeCount
  end

  def pickAnOrange
    if @orangeCount == 0
      puts "No more oranges"
    else
      @orangeCount -= 1
      puts "Delicious orange"
    end
  end

  def oneYearPasses
    @age += 1
    @height += 2
    if @age > 10
      initialize
      puts "Die"
    elsif @age > 5
      @orangeCount = @age - 5
    end
  end
end

tree = OrangeTree.new
12.times {
  puts "height: " + tree.height.to_s + ", oranges: " + tree.countTheOrange.to_s
  tree.oneYearPasses
}