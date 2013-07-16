# griddable.rb
# Utility class to go from a nested array tree
# to a grid that can (e.g) be rendered in html
# Parent and child classes can overlap in making the grid, e.g:
# ['a', ['a1', ['a1a', ['a1a1', 'a1a2']]],
#		       ['a2', ['a2a', 'a2b']] ]
# =>
#   a  a1  a1a  a1a1
#               a1a2
#      a2  a2a
#          a2b
class GriddableArray < Array

# Get the maximum depth of a nested array - an un-nested array has depth 1
	def max_depth
		t = dup
		depth = 1

		until t==flatten
			depth += 1
			t = t.flatten(1)
		end

		depth
	end

# Get the maximum width of a nested array, using the rules described for this class
	def max_width
		if self==flatten
# Not nested
			return count
		end

		width, nest_width = 0,0
		each do |item|
			if item.kind_of?(Array)
				nest_width += GriddableArray.new(item).max_width
			else
				width += 1
			end
		end

		[width, nest_width].max
	end

# Convert a nested array to a grid. Unused cells will be nil, and suppressed
# if they appear after the end of a row
	def to_grid
		g = Array.new
		put_in_grid(g, 0, 0, self)

		g
	end

	private

# Recursively put an item, which may be nested, into a grid,
# which will grow appropriately, return the new y value
# Params:
#  +g+:: target grid
#  +x+:: start x (depth) position
#  +y+:: start y (width) position
#  +item+:: the item to put
	def put_in_grid(g, x, y, item)
		gi, ngi = y,y
		item.each do |child|
			if child.kind_of?(Array)
				ngi += put_in_grid(g, x+1, ngi, child)
			else
				if g[gi].nil?
					g[gi] = Array.new
				end

				g[gi][x] = child
				gi += 1
			end
		end

		[gi, ngi].max
	end

end
