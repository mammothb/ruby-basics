# all natural numbers are either primes or can be represented as
# a product of primes:
# At most 1 prime factor can be bigger than sqrt(n).
# Proof by contradiction:
# suppose p and q are prime factors of n, and p, q >= sqrt(n)
# pq <= n
# pq >= sqrt(n)^2 >= n (Contradiction)

t = Time.now
n = 600851475143
lastFactor = 1
while n % 2 == 0
  lastFactor = 2
  n /= 2
end
maxFactor = Math.sqrt(n)
factor = 3
while n > 1 && factor <= maxFactor
  if n % factor == 0
    n /= factor
    lastFactor = factor
    while n % factor == 0
      n /= factor
    end
    maxFactor = Math.sqrt(n)
  end
  factor += 2
end

puts n == 1 ? lastFactor : n
puts "Time: #{Time.now - t}"