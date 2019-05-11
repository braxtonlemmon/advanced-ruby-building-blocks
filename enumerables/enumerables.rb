#!/home/braxton/.rbenv/shims/ruby

module Enumerable
    def my_each
        return self.to_enum(:my_each) unless block_given?
        if self.class == Hash
            for k in self.keys
                yield k, self[k]
            end
        else
            self.length.times { |i| yield self[i] }
        end
        self
    end

    def my_each_with_index
        return self.to_enum(:my_each_with_index) unless block_given?
        if self.class == Hash
            i = 0
            for k in self.keys
                yield k, self[k], i
                i += 1
            end
        else
            self.length.times { |i| yield self[i], i }
        end
        self
    end

    def my_select
        return self.to_enum(:my_select) unless block_given?
        if self.class == Hash
            hash = {}
            self.my_each {|k, v| hash[k] = v if yield k, v }
            hash
        else
            array = []
            self.my_each { |x| array << x if yield x }
            array
        end
    end

    def my_all?
        return true unless block_given?
        if self.class == Hash
            self.my_each { |k, v| return false if !yield k, v }
        else
            self.my_each { |x| return false if !yield x }
        end
        true
    end

    def my_any?
        return true unless block_given?
        if self.class == Hash
            self.my_each { |k, v| return true if yield k, v }
        else
            self.my_each { |x| return true if yield x }
        end
        false
    end

    def my_none?
        return false unless block_given?
        if self.class == Hash
            self.my_each { |k, v| return false if yield k, v }
        else
            self.my_each { |x| return false if yield x }
        end
        true
    end

    def my_count
        return self.size unless block_given?
        counter = 0
        if self.class == Hash
            self.my_each { |k, v| counter += 1 if yield k, v }
        else
            self.my_each { |x| counter += 1 if yield x }
        end
        counter
    end

    def my_map(&block)
        return self.to_enum(:my_map) unless block_given?
        new_map = []
        if self.class == Hash
            self.my_each { |k, v| new_map << block.call(k, v) }
        else
            self.my_each { |x| new_map << block.call(x) }
        end
        new_map
    end

    def my_inject(*args)
        result = 0
        if args[0].class == Symbol
            op = args[0]
            result = self[0]
            self[1..-1].my_each { |x| result = result.send op, x }
        elsif args.length > 0
            result = args[0]
            if args[1].class == Symbol
                op = args[1]
                self.my_each { |x| result = result.send op, x }
            else
                self.my_each { |x| result = yield result, x }
            end
        else
            result = self[0]
            self[1..-1].my_each { |x| result = yield result, x }
        end
        result
    end
end


#TESTS

# names = ['Charles', 'Brian', 'Zoe', 'Martin', 'Clarence']
# food = ['Banana', 'Pizza', 'Spaghetti', 'Tofu', 'Mushrooms']
# nums = [33, 62, 123, 8, 0, 99, 24]
# stuff = {carrots: 3, frogs: 6, nickels: 2, sofas: 8 }

# #my_each
    # nums.my_each { |num| puts num }
    # p nums.my_each
    # stuff.my_each {|key, value| p "There are #{value} #{key}" }
    # names.my_each { |word| puts word + '!' }

# #my_each_with_index
    # food.my_each_with_index do |word, i|
    #     puts "The word '#{word}' is at index #{i}"
    # end

    # stuff.each_with_index do |(k, v), i|
    #     p k, v, i
    # end

    # stuff.my_each_with_index do |k, v, i|
    #     p k, v, i
    # end

# # #my_select
#     p food.select { |word| word.include?('a') }
#     p food.my_select { |word| word.include?('a') }
#     p stuff.select { |key, value| value > 3 }
#     p stuff.my_select { |key, value| value > 3 }

# #my_all?
    # p names.my_all? { |name| (name.length > 2) } #true
    # p names.my_all? { |name| (name.length > 5) } #false
    # p stuff.all? { |k, v| v > 3 } #false
    # p stuff.my_all? { |k, v| v > 3 } #false
    # p stuff.my_all? { |k, v| v > 1 } #true


# #my_any?
    # p names.my_any? { |name| name.include?('Z') } #true
    # p names.my_any? { |name| name.include?('X') } #false
    # p stuff.any? { |k, v| v > 7 } # true
    # p stuff.my_any? { |k, v| v > 7 } #true
    # p stuff.any? { |k, v| v > 8 } # false
    # p stuff.my_any? { |k, v| v > 8 } # false

# #my_none?
    # p names.my_none? { |name| name.length > 20 } #true
    # p names.my_none? { |name| name.length > 3 } #false
    # p stuff.none? { |k, v| k == "Potato" } #true
    # p stuff.my_none? { |k, v| k == "Potato" } #true
    # p stuff.none? { |k, v| k == :sofas } #false
    # p stuff.my_none? { |k, v| k == :sofas } #false

# #my_count
    # p names.my_count { |name| name.include?('a') } #4
    # p names.count { |name| name.include?('a') } #4
    # p stuff.my_count { |k, v| v > 3 } #2
    # p stuff.count { |k, v| v > 3 } #2
    # p stuff.my_count #4

# #my_map
    # p names.map { |name| name + 'yuh' }
    # p names.my_map { |name| name + 'yuh' }

    # p names.map
    # p names.my_map

    # p stuff.map { |k, v| "key: #{k} value: #{v + 5}" }
    # p stuff.my_map { |k, v| "key: #{k} value: #{v + 5}" }
    
    # p stuff.map
    # p stuff.my_map
    
    # trial = Proc.new { |k, v| "KEY: #{k.upcase} AND VALUE: #{v}" }
    # p stuff.map(&trial)
    # p stuff.my_map(&trial)

# #my_inject
    # p nums.inject { |sum, num| sum + num }
    # p nums.inject(:+)

    # def multiply_els(array)
    #     array.inject { |total, num| total * num }
    # end

    # p multiply_els([2,4,5]) 

    # def multiply_elz(array)
    #     array.my_inject { |total, num| total * num }
    # end

    # p multiply_elz([2,4,5])

    # p nums.inject(:+) #349
    # p nums.my_inject(:+) #349

    # p nums.inject(400, :-) #51
    # p nums.my_inject(400, :-) #51

    # p nums.inject(0) { |sum, num| sum + num + 100 } #1049
    # p nums.my_inject(0) { |sum, num| sum + num + 100 } #1049

    # p nums.inject { |sum, num| sum + (num * 2) } #665
    # p nums.my_inject { |sum, num| sum + (num * 2) } #665

    # p nums.inject(5) { |sum, num| sum + num } #354
    # p nums.my_inject(5) { |sum, num| sum + num } #354
