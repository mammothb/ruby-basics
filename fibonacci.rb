def fibs(n)
  seq = Array.new(n)
  n.times { |i| seq[i] = i < 2 ? i : seq[i - 1] + seq[i - 2] }
  seq
end

def fibs_rec(n, arr = [])
  n == 0 ? arr : fibs_rec(n - 1, arr.push(arr.length < 2 ? arr.length : arr[-2] + arr[-1]))
end

p fibs(0)
p fibs(1)
p fibs(5)
p fibs(10)

p fibs_rec(0)
p fibs_rec(1)
p fibs_rec(5)
p fibs_rec(10)