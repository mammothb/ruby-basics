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
    self.my_each do |x|
      if block
        return false unless yield(x)
      else
        return false unless x
      end
    end
    true
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

# p ([4, 3, 78, 2, 0, 2].each do |x|
#   puts x
# end)

# p ([4, 3, 78, 2, 0, 2].my_each do |x|
#   puts x
# end)

# p ([4, 3, 78, 2, 0, 2].each_with_index do |x, i|
#   puts "#{i}: #{x}"
# end)

# p ([4, 3, 78, 2, 0, 2].my_each_with_index do |x, i|
#   puts "#{i}: #{x}"
# end)

# p ([4, 3, 78, 2, 0, 2].select do |x|
#   x > 2
# end)

# p ([4, 3, 78, 2, 0, 2].my_select do |x|
#   x > 2
# end)

# p [4, 3, 78, 2, 0, 2].all?

# p ([4, 3, 78, 2, 0, 2].all? do |x|
#   x > 2
# end)

# p ([4, 3, 78, 2, 0, 2].all? do |x|
#   x < 99
# end)

# p [4, 3, 78, 2, 0, 2].my_all?

# p ([4, 3, 78, 2, 0, 2].my_all? do |x|
#   x > 2
# end)

# p ([4, 3, 78, 2, 0, 2].my_all? do |x|
#   x < 99
# end)

# p [4, 3, 78, 2, 0, 2].any?

# p ([4, 3, 78, 2, 0, 2].any? do |x|
#   x < 0
# end)

# p ([4, 3, 78, 2, 0, 2].any? do |x|
#   x < 99
# end)

# p [4, 3, 78, 2, 0, 2].my_any?

# p ([4, 3, 78, 2, 0, 2].my_any? do |x|
#   x < 0
# end)

# p ([4, 3, 78, 2, 0, 2].my_any? do |x|
#   x < 99
# end)

# p [4, 3, 78, 2, 0, 2].none?

# p ([4, 3, 78, 2, 0, 2].none? do |x|
#   x < 0
# end)

# p ([4, 3, 78, 2, 0, 2].none? do |x|
#   x < 99
# end)

# p [4, 3, 78, 2, 0, 2].my_none?

# p ([4, 3, 78, 2, 0, 2].my_none? do |x|
#   x < 0
# end)

# p ([4, 3, 78, 2, 0, 2].my_none? do |x|
#   x < 99
# end)

# p [4, 3, 78, 2, 0, 2].count

# p ([4, 3, 78, 2, 0, 2].count do |x|
#   x < 0
# end)

# p ([4, 3, 78, 2, 0, 2].count do |x|
#   x < 4
# end)

# p [4, 3, 78, 2, 0, 2].my_count

# p ([4, 3, 78, 2, 0, 2].my_count do |x|
#   x < 0
# end)

# p ([4, 3, 78, 2, 0, 2].my_count do |x|
#   x < 4
# end)

sqr = Proc.new { |x| x ** 2 }

p ([4, 3, 78, 2, 0, 2].map do |x|
  x ** 2
end)

p [4, 3, 78, 2, 0, 2].map(&sqr)

p ([4, 3, 78, 2, 0, 2].my_map do |x|
  x ** 2
end)

p [4, 3, 78, 2, 0, 2].my_map(&sqr)

# p ([4, 3, 78, 2, 0, 2].reduce do |sum, x|
#   sum += x
# end)

# p ([1, 2, 3, 4].reduce do |product, x|
#   product *= x
# end)

# p ([4, 3, 78, 2, 0, 2].reduce(10) do |sum, x|
#   sum += x
# end)

# p ([4, 3, 78, 2, 0, 2].reduce do |sum, x|
#   sum += x
# end)

# p ([1, 2, 3, 4].my_reduce do |product, x|
#   product *= x
# end)

# p ([4, 3, 78, 2, 0, 2].my_reduce(10) do |sum, x|
#   sum += x
# end)

# def multiply_els(arr)
#   arr.my_reduce { |accumulator, x| accumulator *= x }
# end

# p multiply_els([1, 2, 3, 4])

