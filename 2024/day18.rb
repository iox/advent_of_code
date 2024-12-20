require 'set'


class Grid
  def initialize(input, max = 70)
    @input = input
    @grid = Set.new
    @min_x = 0
    @max_x = max
    @min_y = 0
    @max_y = max
    @points = []

    parse(input)
  end

  def parse(input)
    input.split("\n").map(&:strip).each do |line|
      x, y = line.split(",").map(&:to_i)
      @points << [y,x]
    end
  end

  def fall(max_points)
    @points.each_with_index do |point, i|
      return if i >= max_points
      @grid << point
    end
  end

  def render(current_position = nil, debug_steps = [])
    result = ""
    (@min_y..@max_y).each do |y|
      result += "    "
      (@min_x..@max_x).each do |x|
        if @grid.include?([y, x])
          result += "#"
        elsif debug_steps.include?([y, x])
          result += "o"
        elsif current_position == [y, x]
          result += "O"
        else
          result += "."
        end
      end
      result += "\n"
    end
    result
  end

  def minimal_steps
    start = [0, 0]
    goal = [@max_y, @max_x]
    # queue = [[start, 0, []]]
    queue = [[start, 0]]
    visited = { start => 0 }

    while queue.any?
      # point, steps, debug_steps = queue.pop
      point, steps = queue.pop


      # puts "\n\n\n"
      # puts render(point, debug_steps)
      # if point == goal
      #   puts debug_steps.inspect
      #   puts "################ Found goal at #{steps} ################"
      # end
      # sleep 0.1

      # return steps if point == goal

      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dy, dx|
        new_point = [point[0] + dy, point[1] + dx]
        
        next if new_point[0] < @min_y || new_point[0] > @max_y || new_point[1] < @min_x || new_point[1] > @max_x

        next if @grid.include?(new_point)

        if !visited.key?(new_point) || visited[new_point] > steps + 1
          # new_debug_steps = debug_steps + [new_point]
          visited[new_point] = steps + 1
          # queue << [new_point, steps + 1, new_debug_steps]
          queue << [new_point, steps + 1]
        end
      end
    end

    # puts visited.inspect
    return visited[goal]
  end

  def minimal_steps_part2(min: 0)
    max = @points.size

    puts "max: #{max}"
    puts "min: #{min}"
    (min..max).to_a.reverse.each do |bytes|
      grid = Grid.new(@input, @max_x)
      puts "Checking #{bytes}"
      grid.fall(bytes)
      if grid.minimal_steps != nil
        puts "Found at #{bytes}"
        return @points[bytes].reverse
      end
    end

    # loop do
    #   break if queue.empty?
    #   puts "Queue: #{queue.inspect}"

      
    #   bytes = queue.pop
    #   grid = Grid.new(@input)
    #   grid.fall(bytes)
    #   if grid.minimal_steps == nil
    #     # Bisect down
    #     minimum_bytes = bytes


    #     diff_from_min = bytes - min

    #     break if diff_from_min <= 1

    #     next_to_check = bytes - diff_from_min / 2 + 1
    #     queue << next_to_check
    #   else
    #     # Bisect up
    #     diff_from_max = max - bytes
    #     next_to_check = bytes + diff_from_max / 2
    #     queue << next_to_check
    #   end
    # end

    # return @points[minimum_bytes]

  end

end


def part2(input)
  grid = Grid.new(input)
  grid.minimal_steps_part2(min: 1024)
end



def part1(input)
  grid = Grid.new(input)
  grid.fall(1024)
  grid.minimal_steps
end






# puts part1(File.read("day18.txt"))
puts part2(File.read("day18ohm.txt")).inspect

require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    EOF
  end

  def sample_after_12
    <<-EOF
    ...#...
    ..#..#.
    ....#..
    ...#..#
    ..#..#.
    .#..#..
    #.#....
    EOF
  end

  def assert_grid(expectation, grid)
    if expectation.strip != grid.strip
      puts "Expected grid:"
      puts expectation
      puts "\n---------\n"
      puts "Actual grid:"
      puts grid
      puts "\n\n"
      assert_equal true, false
    else
      assert_equal true, true
    end
  end

  def test_part1
    grid = Grid.new(sample, 6)
    grid.fall(12)
    assert_grid sample_after_12, grid.render
    assert_equal 22, grid.minimal_steps
  end

  

  def test_part2
    grid = Grid.new(sample, 6)
    assert_equal [6,1], grid.minimal_steps_part2(min: 12)
  end
end