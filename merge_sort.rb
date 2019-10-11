def merge_sort(arr)
  if arr.length > 1
    mid = arr.length / 2
    left = merge_sort(arr[0...mid])
    right = merge_sort(arr[mid..-1])

    arr.length.times do |i|
      if left.empty? || right.empty?
        arr[i..-1] = left.empty? ? right : left
        break
      else
        arr[i] = left[0] < right[0] ? left.shift : right.shift
      end
    end
  end
  arr
end

p merge_sort([2, 4, 6, 1, 4, 8, 1, 4])