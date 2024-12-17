require 'set'

def parse(input)
  grid = input.split("\n").map(&:strip).map(&:chars)
  start = nil
  grid.each_with_index do |row, y|
    if row.include?("S")
      start = [y, row.index("S")]
    end
  end
  [grid, :east, start]
end

def print_grid(grid, pos, direction, visited, points)
  # sleep 0.1
  print "\n\n Points: #{points}\n"
  y, x = pos
  grid.each_with_index do |row, y2|
    row.each_with_index do |cell, x2|
      if y2 == y && x2 == x
        print direction.to_s[0].upcase
      elsif cell == "S"
        print "."
      elsif visited.include?([y2, x2])
        print "o"
      else
        print cell
      end
    end
    puts
  end
  puts
end

def part1(input)
  grid, direction, start = parse(input)

  queue = []
  queue << [start, direction, 0, []]

  solutions = []
  points_map = {}


  iterations = 0
  while !queue.empty?
    pos, direction, points, steps = queue.pop
    y, x = pos

    iterations += 1
    if iterations % 100000 == 0
      minimum_points = solutions.map{|s| s[0]}.min
      minimum_solutions = solutions.select{|s| s[0] == minimum_points}
      if minimum_solutions.size > 1
        result = minimum_solutions.map{|s| s[1]}.reduce(:+).uniq.size + 1
      else
        result = 0
      end
      puts "Iterations: #{iterations}  Queue size : #{queue.size}  Solutions: #{solutions.size}. Result: #{result}"
    end


    if grid[y][x] == "E"
      # puts "Found one solution!"
      # print_grid(grid, pos, direction, points)
      solutions << [points, steps]
    end

    if grid[y][x] == "#"
      next
    end

    # Moving east
    if direction != :west #Turning 180 degrees is silly
      nx = x+1
      ny = y
      new_points = points.clone
      new_points += (direction == :east ? 1 : 1001)
      new_direction = :east
      new_steps = steps.dup
      new_steps << [y,x]
      if ny >= 0 && nx >= 0 && ny < grid.size && nx < grid[0].size
        current_min_points = points_map[[ny, nx]]
        if current_min_points == nil || current_min_points >= new_points - 1000
          points_map[[ny, nx]] = new_points
          queue << [[ny, nx], new_direction, new_points, new_steps]
        end
      end
    end

    # Moving west
    if direction != :east
      nx = x-1
      ny = y
      new_points = points.clone
      new_points += (direction == :west ? 1 : 1001)
      new_direction = :west
      new_steps = steps.dup
      new_steps << [y,x]
      if ny >= 0 && nx >= 0 && ny < grid.size && nx < grid[0].size
        current_min_points = points_map[[ny, nx]]
        if current_min_points == nil || current_min_points >= new_points - 1000
          points_map[[ny, nx]] = new_points
          queue << [[ny, nx], new_direction, new_points, new_steps]
        end
      end
    end

    # Moving north
    if direction != :south
      nx = x
      ny = y-1
      new_points = points.clone
      new_points += (direction == :north ? 1 : 1001)
      new_direction = :north
      new_steps = steps.dup
      new_steps << [y,x]
      if ny >= 0 && nx >= 0 && ny < grid.size && nx < grid[0].size
        current_min_points = points_map[[ny, nx]]
        if current_min_points == nil || current_min_points >= new_points - 1000
          points_map[[ny, nx]] = new_points
          queue << [[ny, nx], new_direction, new_points, new_steps]
        end
      end
    end

    # Moving south
    if direction != :north
      nx = x
      ny = y+1
      new_points = points.clone
      new_points += (direction == :south ? 1 : 1001)
      new_direction = :south
      new_steps = steps.dup
      new_steps << [y,x]
      if ny >= 0 && nx >= 0 && ny < grid.size && nx < grid[0].size
        current_min_points = points_map[[ny, nx]]
        if current_min_points == nil || current_min_points >= new_points - 1000
          points_map[[ny, nx]] = new_points
          queue << [[ny, nx], new_direction, new_points, new_steps]
        end
      end
    end

  end

  minimal_points = solutions.map(&:first).min
  perfect_solutions = solutions.select{|s| s[0] == minimal_points}
  puts "Finished after #{iterations} iterations. Minimal points: #{minimal_points}. We found #{perfect_solutions.count} perfect solutions"

  perfect_steps = perfect_solutions.map{|s| s[1]}.reduce(:+).uniq

  perfect_steps.size + 1
end




puts part1(File.read("day16.txt"))
# puts part2(File.read("day16.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    EOF
  end
  def sample_part2_result
    <<-EOF
    ###############
    #.......#....O#
    #.#.###.#.###O#
    #.....#.#...#O#
    #.###.#####.#O#
    #.#.#.......#O#
    #.#.#####.###O#
    #..OOOOOOOOO#O#
    ###O#O#####O#O#
    #OOO#O....#O#O#
    #O#O#O###.#O#O#
    #OOOOO#...#O#O#
    #O###.#.#.#O#O#
    #O..#.....#OOO#
    ###############
    EOF
  end

  def sample_b
    <<-EOF
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
    EOF
  end

  def sample_b_part2_result
    <<-EOF
    #################
    #...#...#...#..O#
    #.#.#.#.#.#.#.#O#
    #.#.#.#...#...#O#
    #.#.#.#.###.#.#O#
    #OOO#.#.#.....#O#
    #O#O#.#.#.#####O#
    #O#O..#.#.#OOOOO#
    #O#O#####.#O###O#
    #O#O#..OOOOO#OOO#
    #O#O###O#####O###
    #O#O#OOO#..OOO#.#
    #O#O#O#####O###.#
    #O#O#OOOOOOO..#.#
    #O#O#O#########.#
    #O#OOO..........#
    #################
    EOF


    <<-EOF
    #################
    #...#...#...#..N#
    #.#.#.#.#.#.#.#o#
    #.#.#.#...#...#o#
    #.#.#.#.###.#.#o#
    #ooo#.#.#.....#o#
    #o#o#.#.#.#####o#
    #o#o..#.#.#ooooo#
    #o#o#####.#o###.#
    #o#o#..ooooo#...#
    #o#o###o#####.###
    #o#o#ooo#.....#.#
    #o#o#o#####.###.#
    #o#o#o........#.#
    #o#o#o#########.#
    #.#ooo..........#
    #################
    EOF
  end




  def test_part1
    # assert_equal 7036, part1(sample)
    # assert_equal 11048, part1(sample_b)
  end

  def test_part2
    assert_equal 45, part1(sample)
    assert_equal 64, part1(sample_b)
  end
end