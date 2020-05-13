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

  def my_select
    return enum_for(:my_select) unless block_given?

    arr = []
    my_each do |i|
      arr << i if yield i
    end
    arr
  end
end
