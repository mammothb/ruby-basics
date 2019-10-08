def bubble_sort(arr)
  is_modified = true
  while is_modified
    is_modified = false
    i = 0
    while i < arr.length - 1
      if arr[i] > arr[i + 1]
        tmp = arr[i]
        arr[i] = arr[i + 1]
        arr[i + 1] = tmp
        is_modified = true
      end
      i += 1
    end
  end
  arr
end

puts bubble_sort([4, 3, 78, 2, 0, 2])

def bubble_sort_by(arr)
  is_modified = true
  while is_modified
    is_modified = false
    i = 0
    while i < arr.length - 1
      if yield(arr[i], arr[i + 1]) > 0
        tmp = arr[i]
        arr[i] = arr[i + 1]
        arr[i + 1] = tmp
        is_modified = true
      end
      i += 1
    end
  end
  arr
end

puts (bubble_sort_by(["hi", "hello", "hey"]) do |left, right|
  left.length - right.length
end)