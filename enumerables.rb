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

    arr = []
    my_each do |i|
      arr << i if yield i
    end
    arr
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
    puts check
  end
end

# a = [2, 3, 4, 5, 6]
# a.my_each { |k| puts k + 2 }
# hash = {coconut: 200, banana: 150, apple: 170}
# hash.my_each do |key, value|
# puts "#{key} costs #{value} per kilogram."
# end

# %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# %w[ant bear cat].my_all?(/t/) #=> false
# [1, 2i, 3.14].my_all?(Numeric) #=> true
# [nil, true, 99].my_all? #=> false
# [].my_all? #=> true

# %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# %w[ant bear cat].my_any?(/d/) #=> false
# [nil, true, 99].my_any?(Integer) #=> true
# [nil, true, 99].my_any? #=> true
# [].my_any? #=> false

# %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
# %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
# %w[ant bear cat].my_none?(/d/) #=> true
# [1, 3.14, 42].my_none?(Float) #=> false
# [].my_none? #=> true
# [nil].my_none? #=> true
# [nil, false].my_none? #=> true
# [nil, false, true].my_none? #=> false
