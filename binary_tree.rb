class Node
  attr_accessor :parent, :left, :right, :value

  def initialize(parent = nil, value = nil)
    @parent = parent
    @left = nil
    @right = nil
    @value = value
  end
end

def is_leaf?(node, value)
  value < node.value ? node.left.nil? : node.right.nil?
end

def build_tree(arr)
  root = Node.new(nil, arr[0])

  arr[1..-1].each do |v|
    curr_node = root
    until is_leaf?(curr_node, v)
      curr_node = v < curr_node.value ? curr_node.left : curr_node.right
    end
    node = Node.new(curr_node, v)

    if v < curr_node.value
      curr_node.left = node
    else
      curr_node.right = node
    end
  end
  root
end

a = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
p build_tree(a)
