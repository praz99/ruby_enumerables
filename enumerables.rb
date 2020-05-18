# rubocop:disable Metrics/ModuleLength
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

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/CaseEquality
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

  def my_inject(*args)
    init = args[0] if args[0].is_a?(Integer)
    if args[0].is_a?(Symbol) || args[0].is_a?(String)
      oper = args[0]
    elsif args[0].is_a?(Integer)
      oper = args[1]
    end
    if oper
      to_a.my_each { |x| init = init ? init.send(oper, x) : x }
    else
      to_a.my_each { |x| init = init ? yield(init, x) : x }
    end
    init
  end
  # rubocop:enable Metrics/ModuleLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/CaseEquality
end

# ......END OF ENUMERABLES......

def multiply_els(array)
  array.my_inject { |product, n| product * n }
end
