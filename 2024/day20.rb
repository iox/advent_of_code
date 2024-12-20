require 'set'
require 'matrix'

def parse_input(input, only_internal_barriers: true)
  start = nil
  barriers = []  
  grid = input.split("\n").map.with_index do |line, y|
    line.strip!
    line.chars.each_with_index do |c, x|
      next if only_internal_barriers && (y == 0 || x == 0 || y == input.split("\n").size - 1 || x == line.size - 1)
      if c == "S"
        start = [y, x]
      elsif c == "#"
        barriers << [y, x]
      end
    end
    line.chars
  end
  [start, barriers, grid]
end

def calculate_cheats(input)
  start, barriers, grid = parse_input(input)
  # puts "parsed the input! Start at #{start}"
  original_time = count_picoseconds(grid, start)

  results = {}
  barriers.each_with_index do |barrier, i|
    percentage = (i.to_f / barriers.size) * 100
    puts "#{percentage.round(1)}% Checking barrier #{i + 1} of #{barriers.size}" if i > 200 && i%50 == 0
    new_grid = Marshal.load(Marshal.dump(grid))
    new_grid[barrier[0]][barrier[1]] = "."

    time_after_cheat = count_picoseconds(new_grid, start)
    # if time_after_cheat.nil?
    #   puts "Cheat at #{barrier} was not solvable"
    #   print_grid(new_grid)
    # end
    improvement = time_after_cheat ? original_time - time_after_cheat : 0
    if improvement > 0
      results[improvement] ||= 0
      results[improvement] += 1
      # puts "Cheat at #{barrier} will improve time by #{improvement} picoseconds"
      # print_grid(new_grid)
    elsif time_after_cheat == nil
      # puts "Something went wrong, not solvable"
    else
      # puts "Ignore this cheat at #{barrier}, no improvement"
    end
  end

  results
end

def count_picoseconds(grid, start)
  queue = [[start, 0]]  # Store position and time
  visited = Set.new

  while queue.size > 0
    current, time = queue.shift
    visited << current

    # Check all 4 directions
    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dir|
      new_pos = [current[0] + dir[0], current[1] + dir[1]]
      if grid[new_pos[0]][new_pos[1]] == "E"
        return time + 1
      end

      if grid[new_pos[0]][new_pos[1]] == "." && !visited.include?(new_pos)
        queue << [new_pos, time + 1]
        visited << new_pos
      end
    end
  end

  return nil
end





def print_grid(grid)
  puts "\n\n"
  grid.each do |row|
    puts "   " + row.join
  end
  puts "\n\n"
end



def part1(input, min_savings=100)
  results = calculate_cheats(input)
  # Count only those results whose keys >= min_savings
  valid_results = results.select { |k, v| k >= min_savings }
  # puts "valid results: #{valid_results}"
  valid_results.values.reduce(:+)
end


def picoseconds_per_position(input)
  start, barriers, grid = parse_input(input, only_internal_barriers: false) 
  barriers = barriers.to_set
  
  picoseconds_per_position = { start => 0 }
  visited = Set.new
  queue = [start]

  until queue.empty?
    current = queue.shift
    visited << current
    steps = picoseconds_per_position[current]
    
    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dir|
      new_position = [current[0] + dir[0], current[1] + dir[1]]
      next if (barriers.include?(new_position) || visited.include?(new_position))
      picoseconds_per_position[new_position] = steps + 1
      queue << new_position
    end
  end
  picoseconds_per_position
end

def part2(input, min_savings=100)
  ppp = picoseconds_per_position(input)
  racetrack_positions = ppp.keys.to_set

  # We check all combinations of 2 racetrack positions to see which ones are
    # cheatable (distance between them less than 20)
    # effective (they save at least 100 steps)
  ppp.to_a.sum do |pos1, step1|
    racetrack_positions.delete(pos1).count do |pos2|
      # The cheat is the manhattan distance between 2 points
      cheat = (pos2[0] - pos1[0]).abs + (pos2[1] - pos1[1]).abs
      # Skip if the cheat is longer than 20
      next if cheat > 20
      # The time savings need to be bigger than a certain amount to count
      ppp[pos2] - (step1 + cheat) >= min_savings
    end
  end
end





puts part1(File.read("day20.txt"))
puts part2(File.read("day20.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    EOF
  end
  

  def silly_sample
    <<-EOF
    #######
    ##S...#
    #####.#
    #E....#
    #######
    EOF
  end

  def test_part1
    # start, barriers, grid = parse_input(silly_sample)
    # assert_equal 9, count_picoseconds(grid, start)

    # results = calculate_cheats(silly_sample)
    # assert_equal 3, results.keys.size
    # assert_equal 1, results[2]
    # assert_equal 1, results[4]
    # assert_equal 1, results[6]


    start, barriers, grid = parse_input(sample)
    assert_equal 84, count_picoseconds(grid, start)
    results = calculate_cheats(sample)
    assert_equal 11, results.keys.size
    assert_equal 14, results[2]
    assert_equal 14, results[4]
    assert_equal 2, results[6]
    assert_equal 4, results[8]
    assert_equal 2, results[10]
    assert_equal 3, results[12]
    assert_equal 1, results[20]
    assert_equal 1, results[36]
    assert_equal 1, results[38]
    assert_equal 1, results[40]
    assert_equal 1, results[64]

    assert_equal 4, part1(sample, 30)
  end

  def test_part2
    assert_equal 7, part2(sample, 73)
  end
end