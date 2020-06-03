require_relative '../enumerables'

describe Enumerable do
  let(:my_arr) { [1, 2, 3] }
  let(:my_arr_str) { %w[ant bear cat] }
  let(:my_arr_nil) { [nil, true, 99] }
  let(:my_arr_numeric) { [1, 2i, 3.14] }
  let(:got_arr) { [] }

  describe '#my_each' do
    it 'returns each elements of the array if block is given' do
      expect(my_arr.my_each { |x| got_arr << x }).to eql(got_arr)
    end

    it "returns enumerator if block isn't given." do
      expect(my_arr.my_each.class).to eql(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'returns each elements of the array with index if block is given' do
      my_arr.my_each_with_index { |value, index| got_arr << value + index }
      expect(got_arr).to eql [1, 3, 5]
    end

    it "returns enumerator if block isn't given." do
      expect(my_arr.my_each_with_index.class).to eql(Enumerator)
    end
  end

  describe '#my_select' do
    it 'returns an array of elements when the block returns true.' do
      expect(my_arr.my_select { |x| x > 2 }).to eql([3])
    end

    it "returns enumerator if block isn't given." do
      expect(my_arr.my_select.class).to eql(Enumerator)
    end
  end

  describe '#my_all?' do
    it 'returns true when all items executed in block return true.' do
      expect(my_arr_str.my_all? { |word| word.size > 3 }).to eql(false)
    end

    it "returns false if any value is false when any pattern or block isn't supplied." do
      expect(my_arr_nil.my_all?).to eql(false)
    end

    it 'returns true when pattern supplied if all elements are absolute equal to pattern.' do
      expect(my_arr_str.my_all?(/a/)).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'returns true when any items executed in block returns true.' do
      expect(my_arr_str.my_any? { |word| word.size > 3 }).to eql(true)
    end

    it "returns false if all values are false when any pattern or block isn't supplied." do
      expect(my_arr_nil.my_any?).to eql(true)
    end

    it 'returns true if any element is absolutely equal to given pattern.' do
      expect(my_arr_str.my_any?(/d/)).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'returns true when none of items executed in block returns true.' do
      expect(my_arr_str.my_none? { |word| word.size > 3 }).to eql(false)
    end

    it "returns false if any values is true when any pattern or block isn't supplied." do
      expect(my_arr_nil.my_none?).to eql(false)
    end

    it 'returns false if any element is absolutely equal to given pattern.' do
      expect(my_arr_str.my_none?(/d/)).to eql(true)
    end
  end

  describe '#my_count' do
    it 'returns the number of items if any argument or block not given' do
      expect(my_arr.my_count).to eql 3
    end

    it 'returns the number of items egual to argument if any argument given' do
      expect(my_arr.my_count(2)).to eql 1
    end

    it 'returns the number of items executed in block given that returns true' do
      expect(my_arr.my_count { |x| x % 2.odd? }).to eql 2
    end
  end

  describe '#my_map' do
    it 'returns a new array contains elements after formed in the block' do
      expect(my_arr.my_map { |i| i * i }).to eql [1, 4, 9]
    end

    it "returns enumerator if block isn't given." do
      expect(my_arr.my_map.class).to eql(Enumerator)
    end
  end

  describe '#inject' do
    describe 'if accumulator is defined' do
      it 'returns the result of accumulator and items by using given symbol' do
        expect((5..10).reduce(2, :*)).to eql 302_400
      end

      it 'returns the result of accumulator and items by using given block' do
        expect((5..10).inject(2) { |product, n| product * n }).to eql 302_400
      end
    end

    describe "if accumulator isn't defined" do
      it 'returns the result of items by using given symbol' do
        expect((5..10).reduce(:*)).to eql 151_200
      end

      it 'returns the result of items by using given block' do
        expect((5..10).inject { |sum, n| sum + n }).to eql 45
      end

      it 'returns the result of items by using given long block' do
        expect(my_arr_str.inject do |memo, word|
          memo.length > word.length ? memo : word
        end).to eql 'bear'
      end
    end
  end
end
