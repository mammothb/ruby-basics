def getMultipleSum num
  sum = 0
  num.times do |i|
    if i % 3 == 0 || i % 5 == 0
      sum += i
    end
  end
  sum
end

puts getMultipleSum 10
puts getMultipleSum 1000