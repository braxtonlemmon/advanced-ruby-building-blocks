#!/home/braxton/.rbenv/shims/ruby

def bubble_sort(array)
    swapped = true
    while swapped
        swapped = false
        array.each_with_index do |num, i|
            if i + 1 == array.length
                break
            elsif num > array[i + 1]
                array[i], array[i + 1] = array[i + 1], array[i]
                swapped = true
            end
        end
    end
    p array
end

def bubble_sort_by (array, &block)
    swapped = true
    while swapped
        swapped = false
        array.each_with_index do |num, i|
            if i + 1 == array.length
                break
            elsif yield(array[i], array[i + 1]) > 0
                array[i], array[i + 1] = array[i + 1], array[i]
                swapped = true
            end
        end
    end
    p array
end

bubble_sort([6,4,3,11,2])

bubble_sort_by(["hi", "hello", "hey", "octopus", "orange", "yo"]) do |left, right|
    left.length - right.length
end