module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    length.times do |i|
      yield self[i]
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
end

a = [1, 2, 3, 4, 5]
a.my_each { |k| puts k + 2 }
a.my_each_with_index { |j, k| puts "#{j + 10} is at position #{k + 1}" }
