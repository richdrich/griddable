# griddable_hash.rb
# Utility class to go from a nested hash tree
# to a grid that can (e.g) be rendered in html
# Parent and child classes can overlap in making the grid, e.g:
# TBD
class GriddableHash < Hash

# Get the maximum depth of a nested hash - an un-nested hash has depth 1
	def max_depth

		res = 1

		each do |k,v|
			if v.kind_of?(Array)
				v.each do |child|
					res = [res, 1 + GriddableHash[child].max_depth ].max
				end
			end
		end

		res

	end

# # Get the maximum width of a nested array, using the rules described for this class
# 	def max_width
# 		if self==flatten
# # Not nested
# 			return count
# 		end

# 		width, nest_width = 0,0
# 		each do |item|
# 			if item.kind_of?(Array)
# 				nest_width += Griddable.new(item).max_width
# 			else
# 				width += 1
# 			end
# 		end

# 		[width, nest_width].max
# 	end

# Convert a nested hash to a grid. Unused cells will be nil, and suppressed
# if they appear after the end of a row
	def to_grid
		puts "\nto_grid"
		g = Array.new
		put_hash_in_grid(g, 0, 0, self)

		g
	end

	private

# Recursively put an array of hash scalars and structs, into a grid,
# which will grow appropriately, return the new y value
# Params:
#  +g+:: target grid
#  +x+:: start x (depth) position
#  +y+:: start y (width) position
#  +item+:: the item to put
	def put_array_in_grid(g, x, y, item)
		#  puts "put_array_in_grid x=#{x} y=#{y} #{item}"

		gi = y
		item.each do |hv|
			gi = put_hash_in_grid(g, x, gi, hv)
		end

		# puts "  put_array_in_grid returns #{gi}"
		gi
	end

	def put_hash_in_grid(g, x, y, hashv)
		# puts " put_hash_in_grid x=#{x} y=#{y} #{hashv}"

		gi, ngi = y, y
		hashv.each do |mk, mv|
			if mv.kind_of?(Array)
				ngi += put_array_in_grid(g, x+1, ngi, mv)
			else
				if gi.nil?
					debugger
				end

				if g[gi].nil?
					g[gi] = Array.new
				end

				if g[gi][x].nil?
					g[gi][x] = {mk => mv};
				else
					g[gi][x][mk] = mv;
				end
			end
		end

		rv = [gi+1, ngi].max
		# puts "  put_hash_in_grid returns #{rv}"
		# rv
	end

end
