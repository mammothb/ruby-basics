class Node
  attr_accessor :parent, :left, :right, :value

  def initialize(parent = nil, value = nil)
    @parent = parent
    @left = nil
    @right = nil
    @value = value
  end
end

class BinaryTree
  def build_tree(arr)
    @root = Node.new(nil, arr[0])
  
    arr[1..-1].each do |v|
      curr_node = @root
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
  end

  def breadth_first_search(value)
    queue = [@root]
    until queue.empty?
      curr_node = queue.shift
      return curr_node if curr_node.value == value
      queue.push(curr_node.left) unless curr_node.left.nil?
      queue.push(curr_node.right) unless curr_node.right.nil?
    end
  end

  def depth_first_search(value, strategy)
    stack = []
    case strategy.downcase
    when "preorder"
      stack.push(@root)
      until stack.empty?
        curr_node = stack.pop
        return curr_node if curr_node.value == value
        stack.push(curr_node.right) unless curr_node.right.nil?
        stack.push(curr_node.left) unless curr_node.left.nil?
      end
    when "inorder"
      curr_node = @root
      until stack.empty? && curr_node.nil?
        if curr_node
          stack.push(curr_node)
          curr_node = curr_node.left
        else
          curr_node = stack.pop
          return curr_node if curr_node.value == value
          curr_node = curr_node.right
        end
      end
    when "postorder"
      prev_node = nil
      curr_node = @root
      loop do
        until curr_node.nil?
          stack.push(curr_node)
          curr_node = curr_node.left
        end
        while curr_node.nil? && !stack.empty?
          curr_node = stack.last
          if curr_node.right.nil? || curr_node.right == prev_node
            return curr_node if curr_node.value == value
            stack.pop
            prev_node = curr_node
            curr_node = nil
          else
            curr_node = curr_node.right
          end
        end
        break if stack.empty?
      end
    else
      puts "Invalid strategy"
    end
  end

  def dfs_rec(value, strategy, node = @root)
    ret = nil
    case strategy
    when "preorder"
      ret ||= node if node.value == value
      ret ||= dfs_rec(value, strategy, node.left) unless node.left.nil?
      ret ||= dfs_rec(value, strategy, node.right) unless node.right.nil?
    when "inorder"
      ret ||= dfs_rec(value, strategy, node.left) unless node.left.nil?
      ret ||= node if node.value == value
      ret ||= dfs_rec(value, strategy, node.right) unless node.right.nil?
    when "postorder"
      ret ||= dfs_rec(value, strategy, node.left) unless node.left.nil?
      ret ||= dfs_rec(value, strategy, node.right) unless node.right.nil?
      ret ||= node if node.value == value
    else
      puts "Invalid strategy"
    end
    ret
  end
  
  private
    def is_leaf?(node, value)
      value < node.value ? node.left.nil? : node.right.nil?
    end
end



a = [6, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = BinaryTree.new
tree.build_tree(a)

# p tree
# p tree.depth_first_search(6345, "preorder")
# p tree.depth_first_search(6345, "inorder")
# p tree.depth_first_search(6345, "postorder")
# p tree.dfs_rec(6345, "preorder")
# p tree.dfs_rec(6345, "inorder")
# p tree.dfs_rec(6345, "postorder")
p tree.depth_first_search(6345, "preorder") == tree.dfs_rec(6345, "preorder")
p tree.depth_first_search(6345, "inorder") == tree.dfs_rec(6345, "inorder")
p tree.depth_first_search(6345, "postorder") == tree.dfs_rec(6345, "postorder")