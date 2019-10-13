class Board
  SIZE = 8.freeze

  def self.valid_move?(x, y)
    x.between?(0, SIZE - 1) && y.between?(0, SIZE - 1)
  end
end

class Node
  attr_reader :x, :y, :parent

  def initialize(x, y, parent = nil)
    @x = x
    @y = y
    @parent = parent
  end

  def path
    path_list = [[x, y]]
    root = @parent
    until root.nil?
      path_list.unshift([root.x, root.y])
      root = root.parent
    end
    path_list
  end
end

def knight_moves(from, to)
  moveset = [[2, -1], [2, 1], [-2, -1], [-2, 1], [-1, 2], [1, 2], [-1, -2],
    [1, -2]]
  visited = Array.new(Board::SIZE) { Array.new(Board::SIZE, false) }
  from_node = Node.new(from[0], from[1])
  to_node = nil

  queue = [from_node]
  until queue.empty?
    node = queue.shift
    x = node.x
    y = node.y
    
    if [x, y] == to
      to_node = node
      break
    end
    unless visited[x][y]
      visited[x][y] = true
      moveset.each do |x_move, y_move|
        x_new = x + x_move
        y_new = y + y_move
        if Board.valid_move?(x_new, y_new)
          queue.push(Node.new(x_new, y_new, node))
        end
      end
    end
  end
  to_node.path
end

p knight_moves([0, 0], [1, 2])
p knight_moves([0, 0], [3, 3])
p knight_moves([3, 3], [0, 0])
p knight_moves([0, 0], [7, 7])
