require 'set'
class Set
  def pop
    el = self.to_a.sample
    self.delete(el)
    el
  end
end


def part1(input)
  calculated_regions = regions(input)
  calculated_regions.map { |r| r[1] * r[2] }.reduce(:+)
end

def part2(input)
  calculated_regions = regions_part2(input)
  sum = 0
  calculated_regions.each do |r|
    cost = r[1] * r[2]
    sum += cost
  end
  sum
end


def regions(input)
  regions = []
  
  # All right, now for part2 I need to count the sides instead of the total perimeter
  

  # Make a "map" of all points (Hash: {[0,0] => "A"}, [0,1] => "B", ...)
  map = {}
  input.split("\n").map(&:strip).each_with_index do |row, y|
    row.chars.each_with_index do |value, x|
      map[[y,x]] = value
    end
  end

  # Loop + break if map is empty
  loop do
    break if map.empty?
    
    # Start a new loop to find all the plots
    position = map.first[0]
    value = map.first[1]
    fences_count = 0
    plots = Set[]
    queue = Set[position]

    loop do
      break if queue.empty?

      pos = queue.pop
      y,x = pos

      # Save current position in the list of plots of this region
      plots << pos

      # Check the left side
      left = [y,x-1]
      if map[left] == value
        queue << left if !plots.include?(left) # Skip if we have already been there
      else
        fences_count += 1
      end

      # Check the top side
      top = [y-1,x]
      if map[top] == value
        queue << top if !plots.include?(top) # Skip if we have already been there
      else
        fences_count += 1
      end

      # Check the right side
      right = [y,x+1]
      if map[right] == value
        queue << right if !plots.include?(right) # Skip if we have already been there
      else
        fences_count += 1
      end

      # Check the bottom side
      bottom = [y+1,x]
      if map[bottom] == value
        queue << bottom if !plots.include?(bottom) # Skip if we have already been there
      else
        fences_count += 1
      end

    end

    regions << [value, plots.count, fences_count]
    plots.each do |plot|
      map.delete(plot)
    end

  end
  
  regions
end


def regions_part2(input)
  regions = []
  
  # All right, now for part2 I need to count the sides instead of the total perimeter
  

  # Make a "map" of all points (Hash: {[0,0] => "A"}, [0,1] => "B", ...)
  map = {}
  input.split("\n").map(&:strip).each_with_index do |row, y|
    row.chars.each_with_index do |value, x|
      map[[y,x]] = value
    end
  end

  # Loop + break if map is empty
  loop do
    break if map.empty?
    
    # Start a new loop to find all the plots
    position = map.first[0]
    value = map.first[1]
    edges_count = 0
    plots = Set[]
    queue = Set[position]
    left_edges = Set[]
    right_edges = Set[]
    top_edges = Set[]
    bottom_edges = Set[]

    # Loop to find all the plots of this region
    loop do
      break if queue.empty?

      pos = queue.pop
      y,x = pos

      # Save current position in the list of plots of this region
      plots << pos
      left_edges << [y,x] if map[[y,x-1]] != value
      right_edges << [y,x] if map[[y,x+1]] != value
      top_edges << [y,x] if map[[y-1,x]] != value
      bottom_edges << [y,x] if map[[y+1,x]] != value

      # Check the left side
      left = [y,x-1]
      if map[left] == value
        queue << left if !plots.include?(left) # Skip if we have already been there
      end

      # Check the top side
      top = [y-1,x]
      if map[top] == value
        queue << top if !plots.include?(top) # Skip if we have already been there
      end

      # Check the right side
      right = [y,x+1]
      if map[right] == value
        queue << right if !plots.include?(right) # Skip if we have already been there
      end

      # Check the bottom side
      bottom = [y+1,x]
      if map[bottom] == value
        queue << bottom if !plots.include?(bottom) # Skip if we have already been there
      end
    end



    # # Now we have to find all the outer edges of this region
    # # We start by finding the max_y and min_y
    # max_y = plots.map(&:first).max
    # min_y = plots.map(&:first).min
    # # Then in max_y, we find min_x_first_row so we have the top left corner
    # min_x_first_row = plots.select { |p| p.first == min_y }.map(&:last).min

    # top_left_corner = [min_y, min_x_first_row]

    # direction = "right" # We start by going right always
    # edges_count += 1
    # current_pos = top_left_corner.dup # the slot to the right of the top left corner


    # loop do
    #   next_top =    [current_pos[0]-1, current_pos[1]]
    #   next_bottom = [current_pos[0]+1, current_pos[1]]
    #   next_right =  [current_pos[0], current_pos[1]+1]
    #   next_left  =  [current_pos[0], current_pos[1]-1]
    #   next_top_left = [current_pos[0]-1, current_pos[1]-1]
    #   next_top_right = [current_pos[0]-1, current_pos[1]+1]
    #   next_bottom_left = [current_pos[0]+1, current_pos[1]-1]
    #   next_bottom_right = [current_pos[0]+1, current_pos[1]+1]
      
    #   if direction == "right"
    #     # What options do we have when moving right?
    #     #     A
    #     # 1) *A > need to turn up
    #     #     A
        
    #     if map[next_right] == value && map[next_top_right] == value
    #       current_pos = next_top_right
    #       direction = "up"
    #       edges_count += 1

    #     # 2) *A > need to continue straight
    #     elsif map[next_right] == value
    #       current_pos = next_right

    #     # 3) *  >  need to turn down
    #     #    A
    #     elsif map[next_bottom] == value
    #       direction = "down"
    #       edges_count += 1
        
    #     # 4) *  >  need to start a U turn
    #     else
    #       direction = "down"
    #       edges_count += 1
    #     end
      

    #   elsif direction == "left"
    #     # What options do we have when moving left?
        
    #     # A
    #     # A*  > need to turn down
    #     # A
    #     if map[next_left] == value && map[next_bottom_left] == value
    #       current_pos = next_bottom_left
    #       direction = "down"
    #       edges_count += 1

    #     # A*  > need to continue going left
    #     elsif map[next_left] == value
    #       current_pos = next_left

    #     # A  > need to turn up
    #     # * 
    #     elsif map[next_top] == value
    #       direction = "up"
    #       edges_count += 1

    #     # A  > need to start a U turn
    #     else
    #       direction = "up"
    #       edges_count += 1
    #     end


      
    #   elsif direction == "up"
    #     # What options do we have when moving up?
        
    #     #    AA
    #     # 1)  *    > need to turn left
    #     if map[next_top] == value && map[next_top_left] == value
    #       current_pos = next_top_left
    #       direction = "left"
    #       edges_count += 1
        
    #     #     A
    #     # 2)  *    > need to continue going up
    #     elsif map[current_pos] == value
    #       current_pos = next_top
        
    #     # 3)  *A   > need to turn right
    #     elsif map[next_right] == value
    #       direction = "right"
    #       edges_count += 1

    #     # 4)  A    > need to start a U turn
    #     else
    #       direction = "right"
    #       edges_count += 1
    #     end

    
      
    #   elsif direction == "down"
    #     # What options do we have when moving down?
        
    #     #  *
    #     #  AA  > need to turn right
    #     if map[next_bottom] == value && map[next_bottom_right] == value
    #       current_pos = next_bottom_right
    #       direction = "right"
    #       edges_count += 1

    #     #  *
    #     #  A  > need to continue going down
    #     elsif map[next_bottom] == value
    #       current_pos = next_bottom

    #     #  A*  > need to turn left
    #     #  
    #     elsif map[next_left] == value
    #       direction = "left"
    #       edges_count += 1

    #     #  * > need to do a U turn and start going up
    #     else
    #       direction = "left"
    #       edges_count += 1
    #     end

    #   end
      
    #   if current_pos == top_left_corner && direction == "up" # Stop when we have finished going around
    #     break
    #   end
    # end
  




    
    # TODO: Find the inner edges in this region
    # Each region is going to have an array plots_with_edges
    # As we navigate each plot, we remove the plot from plots_with_edges
    # If, when we finish navigating, there are still plots in plots_with_edges, we repeat the same logic
    # Take the top left corner, start moving right, etc.


    # loop do
    #   break if plots_with_edges.empty?
    # end

    # This doesn't really work. Example:
    # AAA
    # ABA
    # AAA

    # All the plots with edges have been visited, but we still have 4 edges unaccounted for
    # I might need to figure out a way to identify regions which are surrounded by another region



    # I have a completely new strategy
    # When we navigate the region, we write down the edges we can see in 4 arrays
    # left_edges, right_edges, top_edges, bottom_edges

    # Then, we take each array and we group them
    # All the left edges with the same X are in a line
    # Then, we iterate on them and we check if there is a contiguous edge
    # If there is, we remove it from the array
    # We repear until there is no change in the array
    # Finally we count the edges

    # This has a much better chance of working

    loop do
      before_count = left_edges.count
      left_edges.to_a.sort_by(&:first).each do |edge|
        y,x = edge
        next_top_edge = [y-1,x]
        next_bottom_edge = [y+1,x]
        if left_edges.include?(next_top_edge) || left_edges.include?(next_bottom_edge)
          left_edges.delete(edge)
          break
        end
      end
      after_count = left_edges.count
      break if before_count == after_count
    end

    loop do
      before_count = right_edges.count

      right_edges.to_a.sort_by(&:first).each do |edge|
        y,x = edge
        next_top_edge = [y-1,x]
        next_bottom_edge = [y+1,x]
        if right_edges.include?(next_top_edge) || right_edges.include?(next_bottom_edge)
          right_edges.delete(edge)
          break
        end
      end
      after_count = right_edges.count
      break if before_count == after_count
    end

    loop do
      before_count = top_edges.count
      top_edges.to_a.sort_by(&:last).each do |edge|
        y,x = edge
        next_left_edge = [y,x-1]
        next_right_edge = [y,x+1]
        if top_edges.include?(next_left_edge) || top_edges.include?(next_right_edge)
          top_edges.delete(edge)
          break
        end
      end
      after_count = top_edges.count
      break if before_count == after_count
    end

    loop do
      before_count = bottom_edges.count
      bottom_edges.to_a.sort_by(&:last).each do |edge|
        y,x = edge
        next_left_edge = [y,x-1]
        next_right_edge = [y,x+1]
        if bottom_edges.include?(next_left_edge) || bottom_edges.include?(next_right_edge)
          bottom_edges.delete(edge)
          break
        end
      end
      after_count = bottom_edges.count
      break if before_count == after_count
    end



    edges_count = left_edges.count + right_edges.count + top_edges.count + bottom_edges.count


    regions << [value, plots.count, edges_count]
    plots.each do |plot|
      map.delete(plot)
    end

  end
  
  regions
end

puts part1(File.read("day12.txt"))
puts part2(File.read("day12.txt"))

# results = []
# 40.times do
#   print "."
#   results << part2(File.read("day12debug.txt"))
# end
# puts "results.uniq.count: #{results.uniq.count}"
# puts results.uniq.inspect


require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample_a
    <<-EOF
    AAAA
    BBCD
    BBCC
    EEEC
    EOF
  end
  def sample_a_regions
    [
      ["A", 4, 10],
      ["B", 4, 8],
      ["C", 4, 10],
      ["D", 1, 4],
      ["E", 3, 8]
    ]
  end
  def sample_a_regions_part2
    [
      ["A", 4, 4],
      ["B", 4, 4],
      ["C", 4, 8],
      ["D", 1, 4],
      ["E", 3, 4]
    ]
  end

  def sample_b
    <<-EOF
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    EOF
  end
  def sample_b_regions
    [
      ["O", 21, 36],
      ["X", 1, 4],
      ["X", 1, 4],
      ["X", 1, 4],
      ["X", 1, 4]
    ]
  end
  def sample_c
    <<-EOF
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    EOF
  end
  

  def sample_c_regions
    [["R", 12, 18],
    ["I", 4, 8 ],
    ["C", 14, 28],
    ["F", 10, 18],
    ["V", 13, 20],
    ["J", 11, 20],
    ["C", 1, 4 ],
    ["E", 13, 18],
    ["I", 14, 22],
    ["M", 5, 12],
    ["S", 3, 8 ]]
  end

  def sample_c_regions_part2
    [["R", 12, 10],
    ["I", 4, 4 ],
    ["C", 14, 22],
    ["F", 10, 12],
    ["V", 13, 10],
    ["J", 11, 12],
    ["C", 1, 4 ],
    ["E", 13, 8],
    ["I", 14, 16],
    ["M", 5, 6],
    ["S", 3, 6 ]]
  end
  
  def test_part1
    assert_equal sample_a_regions.size, regions(sample_a).size
    regions(sample_a).each_with_index do |calculated_region, i|
      assert_equal calculated_region, sample_a_regions[i]
    end

    assert_equal sample_b_regions.size, regions(sample_b).size
    regions(sample_b).each_with_index do |calculated_region, i|
      assert_equal calculated_region, sample_b_regions[i]
    end

    assert_equal sample_c_regions.size, regions(sample_c).size
    regions(sample_c).each_with_index do |calculated_region, i|
      assert_equal calculated_region, sample_c_regions[i]
    end

    assert_equal 140, part1(sample_a)
    assert_equal 772, part1(sample_b)
    assert_equal 1930, part1(sample_c)
  end


  def sample_d
    <<-EOF
    EEEEE
    EXXXX
    EEEEE
    EXXXX
    EEEEE
    EOF
  end

  def sample_e
    <<-EOF
    AAAAAA
    AAABBA
    AAABBA
    ABBAAA
    ABBAAA
    AAAAAA
    EOF
  end

  def sample_e_regions_part2
    [
      ["A", 28, 12],
      ["B", 4, 4],
      ["B", 4, 4]
    ]
  end

  def sample_f
    <<-EOF
    AA
    AA
    BA
    EOF
  end

  def sample_f_regions_part2
    [
      ["A", 5, 6],
      ["B", 1, 4]
    ]
  end

  def test_part2
    assert_equal 2, regions_part2(sample_f).size
    regions_part2(sample_f).each_with_index do |calculated_region, i|
      assert_equal sample_f_regions_part2[i], calculated_region
    end

    assert_equal 5, regions_part2(sample_a).size
    regions_part2(sample_a).each_with_index do |calculated_region, i|
      assert_equal sample_a_regions_part2[i], calculated_region
    end
    assert_equal 80, part2(sample_a)

    assert_equal 3, regions_part2(sample_d).size
    assert_equal 236, part2(sample_d)

    assert_equal 3, regions_part2(sample_e).size
    regions_part2(sample_e).each_with_index do |calculated_region, i|
      assert_equal sample_e_regions_part2[i], calculated_region
    end
    assert_equal 368, part2(sample_e)

    regions_part2(sample_c).each_with_index do |calculated_region, i|
      assert_equal sample_c_regions_part2[i], calculated_region
    end
    assert_equal 1206, part2(sample_c)
  end
end