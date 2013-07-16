# griddable_spec.rb

require_relative 'griddable_hash'
require 'ruby-debug'

describe GriddableHash, '#max_depth' do
	it 'returns 1 for unnnested hash' do
		unnest = GriddableHash[{:a => 1, :b => 2, :c => 3}];

		unnest.max_depth.should eq(1)
	end

	it 'returns 2 for single nest' do

		nest2 = GriddableHash[{:a => 1, :contents => [{:a1 => 1, :a2 => 2}], :b => 4}];

		nest2.max_depth.should eq(2)
	end

	it 'returns 4 for 4 deep' do
		nest3 = GriddableHash[{:a => 1, :contents => [ {:a1 => 11,
			:contents => [ {:a1a => 111, :contents => [{:a1a1 => 1111, :a2a2 => 1112}]} ] } ] }];

		nest3.max_depth.should eq(4)
	end
end

# describe GriddableHash, '#max_width' do
# 	it 'returns count for unnnested array' do
# 		unnest = GriddableHash.new([1,2,3]);

# 		unnest.max_width.should eq(3)
# 	end

# 	it 'returns width of single nest' do
# #
# #  1 2
# #  4 3
# 		nest2 = GriddableHash.new([1,[2,3],4]);

# 		nest2.max_width.should eq(2)
# 	end

# 	it 'returns 2 for 4 deep' do
# 		nest4 = GriddableHash.new([1,[[[2,3],4],5],6]);
# #
# #   1     2
# #   6 5 4 3
# 		nest4.max_width.should eq(2)
# 	end

# 	it 'returns correct for example' do
# 		nest_t = GriddableHash.new(['a', ['a1', ['a1a', ['a1a1', 'a1a2']]],
# 		                             ['a2', ['a2a', 'a2b']] ]);
# #   a  a1  a1a  a1a1
# #               a1a2
# #      a2  a2a
# #          a2b
# 		nest_t.max_width.should eq(4)
# 	end
# end

 describe GriddableHash, '#to_grid' do
 	it 'returns single cell for unnnested array' do
 		unnest = GriddableHash[{:a => 1, :b => 2, :c => 3}];

 		unnest.to_grid.should eq([[{:a => 1, :b => 2, :c => 3}]])
 	end

 	it 'returns ok for 2 level' do
 		nest2 = GriddableHash[{ :a=>1, :contents=> [
 			{:a1 => 11},
 			{:a2 => 12}
 		]}]

 #  a=1 a1=11
 #      a2=12

    nest2.to_grid.should eq([
    	[{:a => 1}, {:a1 => 11}],
    	[nil,       {:a2 => 12}],
    	])
 	end

 	it 'returns ok for 3 level' do
 		nest3 = GriddableHash[{ :a=>1, :contents=> [
 			{:a1 => 11, :contents => [{:a1a => 111}, {:a1b => 112}]},
 			{:a2 => 12, :contents => [{:a2a => 121}]}
 		]}]

 #  a=1 a1=11 a1a=111
 #            a1b=112
 #      a2=12 a2a=121

    nest3.to_grid.should eq([
    	[{:a => 1}, {:a1 => 11}, {:a1a => 111}],
    	[nil, 			nil,         {:a1b => 112}],
    	[nil,       {:a2 => 12}, {:a2a => 121}],
    	])
 	end


 	it 'returns correct for nest 4' do
 		nest4 = GriddableHash[{:a => 1, :contents => [
 			{:a1 => 11,
			 :contents => [ {:a1a => 111, :contents => [{:a1a1 => 1111}, {:a1a2 => 1112}] } ] },
			{ :a2 => 12,
			 :contents => [ {:a2a => 121}, {:a2b => 122} ]}
		] }];
#    a=1 a1=11 a1a=111 a1a1=1111
#                      a1a2=1112
#        a2=12 a2a=121
#              a2b=122

 		nest4.to_grid.should eq([
 			[ {:a => 1}, {:a1 => 11}, {:a1a => 111}, {:a1a1 => 1111}],
 			[ nil,       nil,         nil,           {:a1a2 => 1112}],
 			[ nil,       {:a2 => 12}, {:a2a => 121}],
 			[ nil,       nil,         {:a2b => 122}],
 			]);
 	end
 end

