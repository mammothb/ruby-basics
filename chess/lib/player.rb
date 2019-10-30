# frozen_string_literal: true

# Handles player input for moves and pawn promotion
class Player
  attr_reader :name, :color, :icon

  def initialize(name)
    @name = name
    @color = nil
    @icon = nil
  end

  def color=(color)
    @color = color
    @icon = color == :w ? "\u2654" : "\u265A"
  end

  def make_move
    move = gets.chomp
    until save_game(move) || /^[a-z]\d\s[a-z]\d$/ =~ move ||
          ['0-0', '0-0-0'].include?(move)
      print 'Please use proper move notation ([a..h][1..8] [a..h][1..8]): '
      move = gets.chomp
    end
    save_game(move) ? move.downcase : move
  end

  def promote_pawn
    print 'Please choose a promotion: 1) Queen, 2) Knight, 3) Rook, ' \
          '4) Bishop: '
    choice = gets.chomp
    until save_game(move) || (/^\d$/ =~ choice && choice.to_i.between?(1, 4))
      print 'Please choose only between 1 to 4: '
      choice = gets.chomp
    end
    choice.to_i
  end

  def save_game(move)
    /^save$/i =~ move
  end
end
