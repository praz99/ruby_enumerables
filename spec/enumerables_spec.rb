require_relative '../enumerables'

describe Enumerable do
  let(:my_arr) {[1, 2, 3]}
  let(:my_hash) {{first: 1, second: 2, third: 3}}
  let(:my_range) {(0..5)}
  let(:got_arr) {[]}
  let(:got_arr2) {[]}
  

  describe '#my_each' do
    it 'returns each elements of the array if block is given' do
      expect(my_arr.my_each {|x| got_arr << x}).to eql(got_arr)
    end

    it "returns each value and keys of the range if block isn't given." do
      expect(my_arr.my_each.class).to eql(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'returns each elements of the array with index if block is given' do
      expect(my_arr.my_each_with_index {|value, index| got_arr2 << value}).to eql(got_arr2)
    end

    it "returns each value and keys of the range if block isn't given." do
      expect(my_arr.my_each_with_index.class).to eql(Enumerator)
    end
  end



end