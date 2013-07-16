# GriddableArray_spec.rb

require_relative 'griddable_array'
require 'ruby-debug'

describe GriddableArray, '#max_depth' do
	it 'returns 1 for unnnested array' do
		unnest = GriddableArray.new([1,2,3]);

		unnest.max_depth.should eq(1)
	end

	it 'returns 2 for single nest' do
		nest2 = GriddableArray.new([1,[2,3],4]);

		nest2.max_depth.should eq(2)
	end

	it 'returns 4 for 4 deep' do
		nest4 = GriddableArray.new([1,[[[2,3],4],5],6]);

		nest4.max_depth.should eq(4)
	end
end

describe GriddableArray, '#max_width' do
	it 'returns count for unnnested array' do
		unnest = GriddableArray.new([1,2,3]);

		unnest.max_width.should eq(3)
	end

	it 'returns width of single nest' do
#
#  1 2
#  4 3
		nest2 = GriddableArray.new([1,[2,3],4]);

		nest2.max_width.should eq(2)
	end

	it 'returns 2 for 4 deep' do
		nest4 = GriddableArray.new([1,[[[2,3],4],5],6]);
#
#   1     2
#   6 5 4 3
		nest4.max_width.should eq(2)
	end

	it 'returns correct for example' do
		nest_t = GriddableArray.new(['a', ['a1', ['a1a', ['a1a1', 'a1a2']]],
		                             ['a2', ['a2a', 'a2b']] ]);
#   a  a1  a1a  a1a1
#               a1a2
#      a2  a2a
#          a2b
		nest_t.max_width.should eq(4)
	end
end

describe GriddableArray, '#to_grid' do
	it 'returns column for unnnested array' do
		unnest = GriddableArray.new([1,2,3]);

		unnest.to_grid.should eq([[1],[2],[3]])
	end


	it 'returns correct for example' do
		nest_t = GriddableArray.new(['a', ['a1', ['a1a', ['a1a1', 'a1a2']]],
		                             ['a2', ['a2a', 'a2b']] ]);
#   a  a1  a1a  a1a1
#               a1a2
#      a2  a2a
#          a2b
		nest_t.to_grid.should eq([ ['a', 'a1', 'a1a', 'a1a1'],
								   [nil, nil,  nil,   'a1a2'],
								   [nil, 'a2', 'a2a'],
								   [nil, nil,  'a2b'] ])
	end
end

