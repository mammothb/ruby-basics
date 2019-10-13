require "./lib/caesar_cipher.rb"

RSpec.describe "#caesar_cipher" do
  it "wraps z to a" do
    expect(caesar_cipher("abcdefghijklmnopqrstuvwxyz", 10)).to eql(
      "klmnopqrstuvwxyzabcdefghij")
  end
  
  it "preserves original casing" do
    expect(caesar_cipher("AbcdefghijklMnopqrstuvWxyz", 10)).to eql(
      "KlmnopqrstuvWxyzabcdefGhij")
  end

  it "handles spaces and non-letter characters" do
    expect(caesar_cipher("Abcd efghi, jklMnopq10 rstuvWxyz?", 10)).to eql(
      "Klmn opqrs, tuvWxyza10 bcdefGhij?")
  end

  it "handles empty string" do
    expect(caesar_cipher("", 10)).to eql("")
  end
  
  it "allows keys greater than 26" do
    expect(caesar_cipher("Abcd efghi, jklMnopq10 rstuvWxyz?", 36)).to eql(
      "Klmn opqrs, tuvWxyza10 bcdefGhij?")
  end

  it "returns original string when key is 0" do
    expect(caesar_cipher("Abcd efghi, jklMnopq10 rstuvWxyz?", 0)).to eql(
      "Abcd efghi, jklMnopq10 rstuvWxyz?")
  end
end