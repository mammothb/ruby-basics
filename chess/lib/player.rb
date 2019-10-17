class Player
  attr_reader :name, :color, :icon

  def initialize(name)
    @name = name
    @color = nil
    @icon = nil
  end

  def color=(color)
    @color = color
    @icon = color == "white" ? "\u2654" : "\u265A"
  end

  def get_move
    move = gets.chomp
    until /^[a-z]\d\s[a-z]\d$/ =~ move
      print "Please use proper move notation ([a..h][1..8] [a..h][1..8]): "
      move = gets.chomp
    end
    move
  end
end