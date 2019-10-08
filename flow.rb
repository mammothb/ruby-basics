num = 99
while num != 0
  bottle = num == 1 ? "bottle" : "bottles"
  puts num.to_s + " " + bottle + " of beer on the wall, " + num.to_s + " " +
      bottle + " of beer"
  num -= 1
  if num == 0
    puts "Take one down and pass it around, no more bottles of beer on " +
        "the wall."
  else
    puts "Take one down and pass it around, " + num.to_s + " " + bottle +
      " of beer on the wall."
  end
end
puts "No more bottles of beer on the wall, no more bottles of beer.\n" +
    "Go to the store and buy some more, 99 bottles of beer on the wall."

# counter = 0
# puts "Say something"
# response = gets.chomp
# while true
#   puts "HUH?! SPEAK UP, SONNY!"
#   response = gets.chomp
#   if response == "BYE"
#     counter += 1
#     if counter == 3
#       break
#     end
#   else
#     counter = 0
#   end
# end

puts "Start year?"
startYear = gets.chomp.to_i
puts "End year?"
endYear = gets.chomp.to_i

year = startYear

while year <= endYear
  if year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    puts year
  end
  year += 1
end