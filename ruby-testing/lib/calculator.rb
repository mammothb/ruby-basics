class Calculator
  def add(*nums)
    nums.reduce(&:+)
  end

  def multiply(*nums)
    nums.reduce(1, &:*)
  end

  def subtract(a, *nums)
    nums.reduce(a, &:-)
  end

  def divide(a, *nums)
    nums.map(&:to_f).reduce(a.to_f, &:/)
  end
end