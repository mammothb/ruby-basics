# require "rest-client"

# File.open("wiki-page.html", "w") do |file|
#   file.write(RestClient.get("http://en.wikipedia.org/wiki"))
# end

require "open-uri"

url = "http://ruby.bastardsbook.com/files/fundamentals/hamlet.txt"

File.open("hamlet.txt", "w") { |file| file.write(open(url).read) }

is_hamlet_speech = false
File.open("hamlet.txt", "r") do |file|
  # file.readlines.each_with_index do |line, i|
  #   puts line if i % 42 == 41
  # end
  file.readlines.each do |line|
    if is_hamlet_speech && (line.match(/^  [A-Z]/) || line.strip.empty?)
      is_hamlet_speech = false
    end

    is_hamlet_speech = true if line.match(/Ham\./)
    puts line if is_hamlet_speech
  end
end