words = []

word = ""
while true
  puts "Enter word"
  word = gets.chomp
  if word == ""
    break
  end
  words.push word
end

changed = true
while changed
  changed = false
  (words.length - 1).times do |i|
    if words[i + 1] < words[i]
      tmp = words[i]
      words[i] = words[i + 1]
      words[i + 1] = tmp
      changed = true
    end
  end
end

puts "===== output ====="
words.each do |word|
  puts word
end