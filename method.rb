def englishNumber number
  if number < 0
    return "Positve number only"
  end
  if number == 0
    return "zero"
  end

  numStr = ""
  ones = ["", "one", "two", "three", "four", "five", "six", "seven", "eight",
      "nine"]
  tens = ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty",
      "seventy", "eighty", "ninety"]
  teens = ["", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
      "sixteen", "seventeen", "eighteen", "nineteen"]
  write = number % 100
  if write > 10 && write < 20
    numStr = teens[write % 10]
  else
    onesStr = ones[write % 10]
    tensStr = tens[write / 10]

    numStr = tensStr + (tensStr != "" && onesStr != "" ? "-" : "") + onesStr
  end
  number = number / 100
  write = number % 10
  if write > 0
    str = englishNumber write
    numStr = str + (numStr != "" ? " hundred " + numStr : " hundred")
  end
  number = number / 10

  write = number % 1000
  if write > 0
    str = englishNumber write
    numStr = str + (numStr != "" ? " thousand " + numStr : " thousand")
  end

  thousands = ["thousand", "million", "billion", "trillion"]
  i = 0
  while number > 0
    write = number % 1000
    if write > 0
      str = englishNumber write
      numStr = str + (numStr != "" ? " " + thousands[i] + " " + numStr : " " +
          thousands[i])
    end
    number = number / 1000
    i = i + 1
  end

  numStr
end

puts englishNumber  0
puts englishNumber  9
puts englishNumber 10
puts englishNumber 11
puts englishNumber 17
puts englishNumber 32
puts englishNumber 88
puts englishNumber 99
puts englishNumber 100
puts englishNumber 101
puts englishNumber 234
puts englishNumber 3211
puts englishNumber 999999
puts englishNumber 999999999
puts englishNumber 1000000000000
puts englishNumber 921000000000000