module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    length.times do |index|
      if is_a? Array
        yield self[index]
      elsif is_a? Hash
        yield keys[index], self[keys[index]]
      elsif is_a? Range
        yield to_a[index]
      end
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    length.times do |i|
      yield self[i], i
    end
    self
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    result = []
    arr = is_a?(Array) ? self : to_a
    arr.my_each do |i|
      result << i if yield i
    end
    result
  end

  def my_all?(arg = nil)
    check = true
    if arg.class == Class
      my_each { |i| check = false unless arg === i }
    elsif arg.class == Regexp
      my_each { |i| check = false unless arg.match? i }
    elsif block_given?
      my_each { |i| check = false unless yield i }
    elsif arg
      my_each { |i| check = false unless arg == i }
    else
      my_each { |i| check = false unless i }
    end
    check
  end

  def my_any?(arg = nil)
    check = false
    if arg.class == Class
      my_each { |i| check = true if arg === i }
    elsif arg.class == Regexp
      my_each { |i| check = true if arg.match? i }
    elsif block_given?
      my_each { |i| check = true if yield i }
    elsif arg
      my_each { |i| check = true if arg == i }
    else
      my_each { |i| check = true if i }
    end
    check
  end

  def my_none?(arg = nil)
    check = true
    if arg.class == Class
      my_each { |i| check = false if arg === i }
    elsif arg.class == Regexp
      my_each { |i| check = false if arg.match? i }
    elsif block_given?
      my_each { |i| check = false if yield i }
    elsif arg
      my_each { |i| check = false if arg == i }
    else
      my_each { |i| check = false if i }
    end
    check
  end

  def my_count(arg = nil)
    return length unless block_given? || arg

    total = 0
    if arg
      my_each { |i| total += 1 if i == arg }
    elsif block_given?
      my_each { |i| total += 1 if yield i }
    end
    total
  end

  def my_map(&a_proc)
    return to_enum(:my_map) unless block_given?

    result = []
    arr = is_a?(Array) ? self : to_a
    arr.my_each { |i| result << a_proc.call(i) }
    result
  end  
end

# TEST CASES

# ...my_each...
# a = [2, 3, 4, 5, 6]
# a.my_each { |k| puts k + 2 }
# hash = {coconut: 200, banana: 150, apple: 170}
# hash.my_each do |key, value|
# puts "#{key} costs #{value} per kilogram."
# end

# ...my_each_with_index...
# hash = Hash.new
# %w(cat dog wombat).my_each_with_index do |item, index|
# hash[item] = index
# end
# puts hash

# a = %w[apple, ball, cat, dog, elephant]
# a.my_each_with_index do |item, index|
# puts "#{item} is at #{index + 1}."
# end

# ...my_select...
# (1..10).my_select { |i| (i % 3).zero? } #=> [3, 6, 9]
# [1, 2, 3, 4, 5].my_select { |num| num.even? } #=> [2, 4]
# [:foo, :bar].my_select { |x| x == :foo } #=> [:foo]

# ...my_all?...
# %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# %w[ant bear cat].my_all?(/t/) #=> false
# [1, 2i, 3.14].my_all?(Numeric) #=> true
# [nil, true, 99].my_all? #=> false
# [].my_all? #=> true

# ...my_any?...
# %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# %w[ant bear cat].my_any?(/d/) #=> false
# [nil, true, 99].my_any?(Integer) #=> true
# [nil, true, 99].my_any? #=> true
# [].my_any? #=> false

# ...my_none?...
# %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
# %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
# %w[ant bear cat].my_none?(/d/) #=> true
# [1, 3.14, 42].my_none?(Float) #=> false
# [].my_none? #=> true
# [nil].my_none? #=> true
# [nil, false].my_none? #=> true
# [nil, false, true].my_none? #=> false

# ...my_count...
# ary = [1, 2, 4, 2]
# ary.my_count #=> 4
# ary.my_count(2) #=> 2
# ary.my_count { |x| (x % 2).zero? } #=> 3

# ...my_map...
# a = [2, 3, 4, 5, 6]
# a.my_map { |l| l * 2 } #=> [2, 9, 16, 25, 36]
# (1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
# (1..4).my_map { "cat" } #=> ["cat", "cat", "cat", "cat"]
# %w[a b c].my_map(&:upcase) #=> ["A", "B", "C"]
# %w[a b c].my_map(&:class) #=> [String, String, String]
# [2, 4, 7, 11].my_map # <Enumerator: [2, 4, 7, 11]:my_map
# my_proc = proc { |num| num > 10 }
# puts [18, 22, 5, 6].my_map(my_proc) { |num| num < 10 } # true true false false

