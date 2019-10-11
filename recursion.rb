def factorial(n)
  n <= 1 ? 1 : n * factorial(n - 1)
end

p factorial(5)
p factorial(0)

def palindrome(s)
  return true if s.length <= 1
  s[0] == s[-1] ? palindrome(s[1..-2]) : false
end

p palindrome("racecar")
p palindrome("abcddcba")
p palindrome("asdf")
p palindrome("asd")

def beer_song(n)
  if n == 0
    puts "no more bottles of beer on the wall"
  else
    puts "#{n} bottles of beer on the wall"
    beer_song(n - 1)
  end
end

beer_song(10)

def fibonacci(n)
  n <= 1 ? n : fibonacci(n - 1) + fibonacci(n - 2)
end

p fibonacci(0)
p fibonacci(1)
p fibonacci(2)
p fibonacci(5)
p fibonacci(6)
p fibonacci(7)

def flatten_array(arr, result = [])
  arr.each do |elem|
    elem.kind_of?(Array) ? flatten_array(elem, result) : result.push(elem)
  end
  result
end

p flatten_array([[1, 2], [3, 4]])
p flatten_array([[1, [8, 9]], [3, 4]])

int_to_roman_mapping = {
  1000 => "M",
  900 => "CM",
  500 => "D",
  400 => "CD",
  100 => "C",
  90 => "XC",
  50 => "L",
  40 => "XL",
  10 => "X",
  9 => "IX",
  5 => "V",
  4 => "IV",
  1 => "I"
}
def int_to_roman(mapping, number, result = "")
  return result if number == 0
  mapping.each do |k, v|
    quotient, modulus = number.divmod(k)
    result += v * quotient
    return int_to_roman(mapping, modulus, result) if quotient > 0
  end
end

p int_to_roman(int_to_roman_mapping, 1234)
p int_to_roman(int_to_roman_mapping, 998)

roman_to_int_mapping = {
  "M" => 1000,
  "CM" => 900,
  "D" => 500,
  "CD" => 400,
  "C" => 100,
  "XC" => 90,
  "L" => 50,
  "XL" => 40,
  "X" => 10,
  "IX" => 9,
  "V" => 5,
  "IV" => 4,
  "I" => 1
}
def roman_to_int(mapping, roman, result = 0)
  return result if roman.empty?
  if roman.length > 1 && mapping.key?(roman[-2..-1])
    roman_to_int(mapping, roman[0..-3], result + mapping[roman[-2..-1]])
  else
    roman_to_int(mapping, roman[0..-2], result + mapping[roman[-1]])
  end
end

p roman_to_int(roman_to_int_mapping, "MCCXXXIV")
p roman_to_int(roman_to_int_mapping, "CMXCVIII")