require "./lib/enumerable.rb"

RSpec.describe Enumerable do
  describe "#my_each" do
    it "do nothing for empty array" do
      value = 0
      [].my_each { |i| value += i }
      expect(value).to eql(0)
    end

    it "works for array of size 1" do
      value = 0
      [1].my_each { |i| value += i }
      expect(value).to eql(1)
    end

    it "works for longer arrays" do
      value = 0
      [1, 2, 3, 4].my_each { |i| value += i }
      expect(value).to eql(10)
    end
  end

  describe "#my_each_with_index" do
    it "does nothing for empty array" do
      value = ""
      [].my_each_with_index { |v, i| value += "#{v}:#{i}," }
      expect(value).to eql("")
    end

    it "works for size 1 array" do
      value = ""
      [10].my_each_with_index { |v, i| value += "#{v}:#{i}," }
      expect(value).to eql("10:0,")
    end

    it "works for longer arrays" do
      value = ""
      [10, 9, 8].my_each_with_index { |v, i| value += "#{v}:#{i}," }
      expect(value).to eql("10:0,9:1,8:2,")
    end
  end

  describe "#my_select" do
    select_one = Proc.new { |i| i == 1 }
    select_two = Proc.new { |i| i == 2 }
    select_six = Proc.new { |i| i == 6 }
    array = [1, 2, 2, 3, 2]

    it "does nothing for empty array" do
      expect([].select(&select_one)).to eql([])
    end

    it "finds single value" do
      expect(array.select(&select_one)).to eql([1])
    end

    it "finds multiple values" do
      expect(array.select(&select_two)).to eql([2, 2, 2])
    end

    it "returns nothing when value is not found" do
      expect(array.select(&select_six)).to eql([])
    end
  end

  describe "#my_all?" do
    nil_array = [nil, nil, nil]
    array = [2, 34, 6, 8]

    it "works without blocks" do
      expect(nil_array.my_all?).to eql(false)
      expect(array.my_all?).to eql(true)
    end

    it "works with blocks" do
      expect(nil_array.my_all? { |x| x.nil? }).to eql(true)
      expect(array.my_all? { |x| x % 2 == 0 }).to eql(true)
      expect(array.my_all? { |x| x % 2 == 1 }).to eql(false)
    end
  end

  describe "#my_any?" do
    nil_array = [nil, nil, nil]
    mixed_array = [1, 4, nil, 34]

    it "works without blocks" do
      expect(nil_array.my_any?).to eql(false)
      expect(mixed_array.my_any?).to eql(true)
    end

    it "works with blocks" do
      expect(nil_array.my_any? { |x| x.nil? }).to eql(true)
      expect(nil_array.my_any? { |x| x.is_a?(String) }).to eql(false)
      expect(mixed_array.my_any? { |x| x.nil? }).to eql(true)
      expect(mixed_array.my_any? { |x| x % 2 == 0 }).to eql(true)
      expect(mixed_array.my_any? { |x| x % 2 == 1 }).to eql(true)
      expect(mixed_array.my_any? { |x| x.is_a?(String) }).to eql(false)
    end
  end

  describe "#my_none?" do
    nil_array = [nil, nil, nil]
    mixed_array = [1, 4, nil, 34]

    it "works without blocks" do
      expect(nil_array.my_none?).to eql(true)
      expect(mixed_array.my_none?).to eql(false)
    end

    it "works with blocks" do
      expect(nil_array.my_none? { |x| x.nil? }).to eql(false)
      expect(nil_array.my_none? { |x| x.is_a?(String) }).to eql(true)
      expect(mixed_array.my_none? { |x| x.nil? }).to eql(false)
      expect(mixed_array.my_none? { |x| x % 2 == 0 }).to eql(false)
      expect(mixed_array.my_none? { |x| x % 2 == 1 }).to eql(false)
      expect(mixed_array.my_none? { |x| x.is_a?(String) }).to eql(true)
    end
  end

  describe "#my_count" do
    nil_array = [nil, nil, nil]
    mixed_array = [1, 4, nil, 34]

    it "works without blocks" do
      expect(nil_array.my_count).to eql(3)
      expect(mixed_array.my_count).to eql(4)
    end

    it "works with blocks" do
      expect(nil_array.my_count { |x| x.nil? }).to eql(3)
      expect(nil_array.my_count { |x| x.is_a?(String) }).to eql(0)
      expect(mixed_array.my_count { |x| x.nil? }).to eql(1)
      expect(mixed_array.my_count { |x| x % 2 == 0 rescue false }).to eql(2)
      expect(mixed_array.my_count { |x| x % 2 == 1 rescue false }).to eql(1)
      expect(mixed_array.my_count { |x| x.is_a?(String) }).to eql(0)
    end
  end

  describe "#my_map" do
    int_array = [1, 2, 3, 4]
    str_array = ["a", "b", "c"]

    it "using blocks" do
      expect(int_array.my_map { |x| x * 2 }).to eql([2, 4, 6, 8])
      expect(str_array.my_map { |x| x * 2 }).to eql(["aa", "bb", "cc"])
    end

    it "using procs" do
      double = Proc.new { |x| x * 2 }
      expect(int_array.my_map(&double)).to eql([2, 4, 6, 8])
      expect(str_array.my_map(&double)).to eql(["aa", "bb", "cc"])
    end
  end

  describe "#my_reduce" do
    int_array = [1, 2, 3, 4]
    str_array = ["a", "b", "c"]

    it "using blocks with default accumulator" do
      expect(int_array.my_reduce do |accumulator, x|
        accumulator += x * 2
      end).to eql(19)
      expect(str_array.my_reduce do |accumulator, x|
        accumulator += x * 2
      end).to eql("abbcc")
    end

    it "using blocks" do
      expect(int_array.my_reduce(0) do |accumulator, x|
        accumulator += x * 2
      end).to eql(20)
      expect(str_array.my_reduce("") do |accumulator, x|
        accumulator += x * 2
      end).to eql("aabbcc")
    end

    it "using procs with default accumulator" do
      double = Proc.new { |accumulator, x| accumulator += x * 2 }
      expect(int_array.my_reduce(&double)).to eql(19)
      expect(str_array.my_reduce(&double)).to eql("abbcc")
    end

    it "using procs" do
      double = Proc.new { |accumulator, x| accumulator += x * 2 }
      expect(int_array.my_reduce(0, &double)).to eql(20)
      expect(str_array.my_reduce("", &double)).to eql("aabbcc")
    end
  end
end