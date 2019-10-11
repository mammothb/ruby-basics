class LinkedList
  def initialize
    @root = nil
  end

  def append(node)
    if @root.nil?
      @root = node
    else
      curr_node = @root
      until curr_node.next_node.nil?
        curr_node = curr_node.next_node
      end
      curr_node.next_node = node
    end
  end

  def prepend(node)
    node.next_node = @root
    @root = node
  end

  def size
    count = 0
    curr_node = @root
    until curr_node.nil?
      curr_node = curr_node.next_node
      count += 1
    end
    count
  end

  def head
    @root
  end

  def tail
    curr_node = @root
    until curr_node.next_node.nil?
      curr_node = curr_node.next_node
    end
    curr_node
  end

  def at(index)
    count = 0
    curr_node = @root
    until curr_node.nil? || count == index
      curr_node = curr_node.next_node
      count += 1
    end
    curr_node
  end

  def pop
    curr_node = @root
    tail_node = tail
    until curr_node.next_node == tail_node
      curr_node = curr_node.next_node
    end
    curr_node.next_node = nil
    tail_node
  end

  def contains?(value)
    curr_node = @root
    until curr_node.nil?
      if curr_node.value == value
        return true
      end
      curr_node = curr_node.next_node
    end
    false
  end

  def find(value)
    count = 0
    curr_node = @root
    until curr_node.nil?
      if curr_node.value == value
        return count
      end
      curr_node = curr_node.next_node
      count += 1
    end
  end

  def to_s
    ret = ""
    curr_node = @root
    until curr_node.nil?
      ret += "( #{curr_node.value} ) -> "
      curr_node = curr_node.next_node
    end
    ret += "nil"
  end

  def insert_at(index, node)
    if index == 0
      prepend(node)
    else
      count = 0
      curr_node = @root
      until count == index - 1
        # Add additional empty nodes if index > size to match Array
        # behavior
        append(Node.new) if curr_node.next_node.nil?
        curr_node = curr_node.next_node
        count += 1
      end
      node.next_node = curr_node.next_node
      curr_node.next_node = node
    end
  end

  def delete_at(index)
    if index == 0
      @root = @root.next_node
    else
      count = 0
      curr_node = @root
      until count == index - 1 || curr_node.next_node.nil?
        curr_node = curr_node.next_node
        count += 1
      end
      # Does nothing if index > size to match Array behavior
      unless curr_node.next_node.nil?
        curr_node.next_node = curr_node.next_node.next_node
      end
    end
  end
end

class Node
  attr_accessor :next_node, :value

  def initialize
    @value = nil
    @next_node = nil
  end
end

list = LinkedList.new
node_1 = Node.new
node_1.value = 1
node_2 = Node.new
node_2.value = 2
node_3 = Node.new
node_3.value = 3
node_4 = Node.new
node_4.value = 4

list.append(node_1)
list.append(node_2)
list.prepend(node_3)
list.prepend(node_4)

p list
p list.size

p list.head
p list.tail

p list.at(0)
p list.at(1)
p list.at(2)
p list.at(3)
p list.at(4)

p list.pop
p list.pop
p list
list.append(node_1)
list.append(node_2)

p list
p list.contains?(5)
p list.contains?(2)

p list.find(4)
p list.find(2)
p list.find(5)

puts list

node_5 = Node.new
node_5.value = 5
node_6 = Node.new
node_6.value = 6
node_7 = Node.new
node_7.value = 7
node_8 = Node.new
node_8.value = 8
list.insert_at(1, node_5)
list.insert_at(0, node_6)
list.insert_at(6, node_7)
list.insert_at(10, node_8)
puts list

list.delete_at(0)
puts list
list.delete_at(1)
puts list
list.delete_at(8)
puts list
list.delete_at(10)
puts list
