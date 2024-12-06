# watch -c "ruby day6.rb"
# Press F5 to start debugger or "rdbg day6.rb"


def part1_walk(input, max_iterations=nil)
  map = input.split("\n").map(&:strip)
  start_line = map.select{|l| l.include?("^")}[0]
  x = start_line.index("^")
  y = map.index(start_line)
  direction = "^"

  iterations = 0
  while true
    if max_iterations && iterations >= max_iterations
      break
    end

    case direction
    when "^"
      next_y = y - 1
      next_x = x
    when "v"
      next_y = y + 1
      next_x = x
    when "<"
      next_y = y
      next_x = x - 1
    when ">"
      next_y = y
      next_x = x + 1
    end

    if next_y < 0 || next_y < 0 || map[next_y] == nil || map[next_y][next_x] == nil
      puts "Leaving the area!"
      break
    end

    if map[next_y][next_x] == "#"
      direction = case direction
      when "^"
        ">"
      when ">"
        "v"
      when "v"
        "<"
      when "<"
        "^"
      end

      next
    end

    if map[next_y][next_x] == "." || map[next_y][next_x] == "X"
      map[y][x] = "X"
      map[next_y][next_x] = direction
      x = next_x
      y = next_y
    end

    iterations += 1
    # result = "    " +map.join("\n    ")+"\n"
    # puts "After #{iterations} iterations\n____________________\n#{result}"
  end

  result = "    " +map.join("\n    ")+"\n"

  result
end


def part2_walk(input, blocking_position)
  map = input.split("\n").map(&:strip)
  start_line = map.select{|l| l.include?("^")}[0]
  x = start_line.index("^")
  y = map.index(start_line)
  direction = "^"

  # Start position can not be blocking position
  return false if [y,x] == blocking_position

  # Set blocking position in map
  chars = map[blocking_position[0]].chars
  chars[blocking_position[1]] = "O"
  map[blocking_position[0]] = chars.join("")

  # Store old positions
  old_positions = []
  iterations = 0
  
  while true
    # result = "    " +map.join("\n    ")+"\n"
    # puts "After #{iterations} iterations, direction is #{direction}\n____________________\n#{result}"
    if old_positions.include?([direction, y, x])
      puts "Loop detected!"
      return true
    end

    old_positions << [direction, y, x]
    
    case direction
    when "^"
      next_y = y - 1
      next_x = x
    when "v"
      next_y = y + 1
      next_x = x
    when "<"
      next_y = y
      next_x = x - 1
    when ">"
      next_y = y
      next_x = x + 1
    end

    if next_y < 0 || next_y < 0 || map[next_y] == nil || map[next_y][next_x] == nil
      # puts "Leaving the area!"
      return false
    end


    if map[next_y][next_x] == "#" || map[next_y][next_x] == "O"
      direction = case direction
      when "^"
        ">"
      when ">"
        "v"
      when "v"
        "<"
      when "<"
        "^"
      end

      next
    end

    if map[next_y][next_x] == "." || map[next_y][next_x] == "X"
      map[y][x] = "X"
      map[next_y][next_x] = direction
      x = next_x
      y = next_y
    end

    iterations += 1
  end

  result = "    " +map.join("\n    ")+"\n"

  result
end


def part1(input)
  result = part1_walk(input)
  result.count("X")+1
end


def part2(input)
  possible_block_positions = []
  standard_path = part1_walk(input).gsub("^", "X").gsub("v", "X").gsub("<", "X").gsub(">", "X")
  standard_path.split("\n").each_with_index do |line,y|
    line.strip.chars.each_with_index do |char, x|
      possible_block_positions << [y,x] if char == "X"
    end
  end

  require 'concurrent-ruby'

  count = Concurrent::AtomicFixnum.new(0)
  iterations = Concurrent::AtomicFixnum.new(0)
  threads = []

  puts "Possible block positions: #{possible_block_positions.count}"

  possible_block_positions.each_slice((possible_block_positions.size / 16.0).ceil).each do |slice|
    threads << Thread.new do
      slice.each_with_index do |pos, i|
        print "."
        count.increment if part2_walk(input, pos)
        iterations.increment
      end
    end
  end

  threads.each(&:join)

  puts count.value
end






# def parse(input)
#   rules = {}
#   input.split("\n\n")[0].split("\n").each do |r|
#     numbers = r.strip.split("|").map(&:to_i)
#     rules[numbers[0]] ||= []
#     rules[numbers[0]] << numbers[1]
#   end

#   updates = input.split("\n\n")[1].split("\n").map{|u| u.strip.split(",").map(&:to_i)}

#   return rules, updates
# end


# def part1(input)
#   rules, updates = parse(input)
#   count = 0
#   updates.each do |u|
#     if valid?(rules, u)
#       count += u[u.length / 2]
#     end
#   end
#   count
# end




# def part2(input)
#   rules, updates = parse(input)
#   count = 0
#   updates.each do |u|
#     if !valid?(rules, u)
#       fixed_update = fix_order(u, rules)
#       count += fixed_update[fixed_update.length / 2]
#     end
#   end
#   count
# end







# puts part1(File.read("day6.txt"))
puts part2(File.read("day6.txt"))


require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    EOF
  end

  def after_5_sample
    <<-EOF
    ....#.....
    ....^....#
    ....X.....
    ..#.X.....
    ....X..#..
    ....X.....
    .#..X.....
    ........#.
    #.........
    ......#...
    EOF
  end

  def after_9_sample
    <<-EOF
    ....#.....
    ....XXXX>#
    ....X.....
    ..#.X.....
    ....X..#..
    ....X.....
    .#..X.....
    ........#.
    #.........
    ......#...
    EOF
  end

  def after_14_sample
    <<-EOF
    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ....X..#X.
    ....X...X.
    .#..X...v.
    ........#.
    #.........
    ......#...
    EOF
  end

  def end_state
    <<-EOF
    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ..XXXXX#X.
    ..X.X.X.X.
    .#XXXXXXX.
    .XXXXXXX#.
    #XXXXXXX..
    ......#v..
    EOF
  end

  # def test_part1
  #   assert_equal sample, part1_walk(sample, 0)
  #   assert_equal after_5_sample, part1_walk(sample, 5)
  #   assert_equal after_9_sample, part1_walk(sample, 9)
  #   assert_equal after_14_sample, part1_walk(sample, 14)

  #   assert_equal 41, (end_state.count("X")+1)
  #   assert_equal 41, part1(sample)
  # end

  def test_part2
    assert_equal 6, part2(sample)
  end



end