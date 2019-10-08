def clockChime &block
  ((Time.now.hour + 11) % 12 + 1).times do |i|
    puts i + 1
    block.call
  end
end

clockChime do
  puts "DONG"
end

def log blockDescription, &block
  puts "Beginning'" + blockDescription + "'..."
  ret = block.call
  puts "...'" + blockDescription + "' finished, returning: #{ret}"
end

log "outer block" do
  log "some little block" do
    5
  end
  log "yet another block" do
    "asdf"
  end
  false
end

$indent = "  "
$nestingDepth = 0
def betterLog blockDescription, &block
  puts $indent * $nestingDepth + "Beginning'" + blockDescription + "'..."
  $nestingDepth += 1
  ret = block.call
  $nestingDepth -= 1
  puts $indent * $nestingDepth + "...'" + blockDescription +
      "' finished, returning: #{ret}"
end

betterLog "outer block" do
  betterLog "some little block" do
    betterLog "teeny-tiny block" do
      "lots of love"
    end
    42
  end
  betterLog "yet another block" do
    "I love Indian food!"
  end
  true
end