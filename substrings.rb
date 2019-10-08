def substrings(word, dictionary)
  frequency = {}
  dictionary.each do |x|
    count = word.downcase.scan(x).length
    frequency[x] = count if count > 0
  end
  frequency
end

dictionary = ["below", "down", "go", "going", "horn", "how", "howdy", "it",
    "i", "low", "own", "part", "partner", "sit"]

puts substrings("below", dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
