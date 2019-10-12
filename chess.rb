class Node
  attr_reader :x, :y, :path

  def initialize(x, y, path = [])
    @x = x
    @y = y
    @path = path
  end
end

def in_bounds?(x, y)
  x.between?(0, 7) && y.between?(0, 7)
end

def knight_moves(from, to)
  x_move = [2, 2, -2, -2, -1, 1, -1, 1]
  y_move = [-1, 1, -1, 1, 2, 2, -2, -2]
  visited = Array.new(8, Array.new(8, false))
  from_node = Node.new(from[0], from[1], [[from[0], from[1]]])
  to_node = nil

  queue = [from_node]
  until queue.empty?
    node = queue.shift
    x = node.x
    y = node.y
    path = node.path
    
    if [x, y] == to
      to_node = node
      break
    end
    unless visited[x][y]
      visited[x][y] = true
      8.times do |i|
        x_new = x + x_move[i]
        y_new = y + y_move[i]
        if x_new.between?(0, 7) && y_new.between?(0, 7)
          queue.push(Node.new(x_new, y_new, path + [[x_new, y_new]]))
        end
      end
    end
  end
  to_node.path
end

p knight_moves([0, 0], [1, 2])
p knight_moves([0, 0], [3, 3])
p knight_moves([3, 3], [0, 0])
