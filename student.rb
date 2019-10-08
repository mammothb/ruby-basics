class Student
  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other)
    self.grade > other.grade
  end

  protected
    attr_reader :grade
end

a = Student.new("Alice", 12)
b = Student.new("Bob", 34)

puts "Well done! #{a.name}" if a.better_grade_than?(b)
puts "Well done! #{b.name}" if b.better_grade_than?(a)