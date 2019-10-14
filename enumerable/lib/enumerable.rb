module Enumerable
  def my_each
    for i in 0...self.length do
      yield(at(i))
    end
    self
  end

  def my_each_with_index
    for i in 0...self.length do
      yield(at(i), i)
    end
    self
  end

  def my_select
    ret = []
    self.my_each { |x| ret.push(x) if yield(x) }
    ret
  end

  def my_all?(&block)
    self.my_each { |x| return false unless block ? yield(x) : x }
    true
  end

  def my_any?(&block)
    self.my_each { |x| return true if block ? yield(x) : x }
    false
  end

  def my_none?(&block)
    !my_any?(&block)
  end

  def my_count(&block)
    if block
      counter = 0
      self.my_each { |x| counter += 1 if yield(x) }
      counter
    else
      self.length
    end
  end

  def my_map(proc = nil)
    ret = []
    self.my_each { |x| ret.push(proc ? proc.call(x) : yield(x)) }
    ret
  end

  def my_reduce(accumulator = nil, &block)
    self.my_each { |x| accumulator = accumulator ? yield(accumulator, x) : x }
    accumulator
  end
end

# def multiply_els(arr)
#   arr.my_reduce { |accumulator, x| accumulator *= x }
# end

# p multiply_els([1, 2, 3, 4])
