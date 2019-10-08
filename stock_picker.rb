def stock_picker(prices)
  profit = -1
  days = Array.new(2)
  prices.each_with_index do |x, i|
    prices[i..-1].each_with_index do |y, j|
      if y - x > profit
        profit = y - x
        days = [i, i + j]
      end
    end
  end
  days
end

puts stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
puts stock_picker([17, 3, 6, 9, 15, 8, 6, 2, 1])