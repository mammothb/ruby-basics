puts "First name?"
firstName = gets.chomp
puts "Middle name?"
middleName = gets.chomp
puts "Last name?"
lastName = gets.chomp

puts "Hello, " + firstName + " " + middleName + " " + lastName


puts "Favorite number?"
number = gets.chomp.to_i
puts "Bigger number: " + (number + 1).to_s
