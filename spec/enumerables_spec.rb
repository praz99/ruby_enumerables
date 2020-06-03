require '../enumerables'

describe Enumerable do
  let(:my_arr) {[1, 2, 3]}
  let(:my_hash) {{first: 1, second: 2, third: 3}}
  let(:my_range) {(0..5)}

  describe "#my_each" do
    it 'returns each elements of the array if block is given' do
      expect(my_arr.my_each {|x| x}).to eql(my_arr)
    end

    it 'returns each value and keys of the hash if block is given.' do
      expect(my_hash.my_each {|key, value| key[value]}).to eql(my_hash)
    end
  end
end