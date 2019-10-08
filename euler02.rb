sum = 0
a = 0
b = 1
while b < 4000000
  if b % 2 == 0
    sum += b
  end

  tmp = a + b
  a = b
  b = tmp
end

puts sum