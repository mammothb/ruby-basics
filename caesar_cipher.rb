def caesar_cipher(phrase, shift)
  shift_if_alpha = Proc.new do |c|
    if c =~ /[[:alpha:]]/
      distance_from_a = c.upcase.ord - "A".ord
      c = (c.ord - distance_from_a + (distance_from_a + shift) % 26).chr
    end
    c
  end
  phrase.split("").map(&shift_if_alpha).join
end

puts caesar_cipher("What a string!", 5)
