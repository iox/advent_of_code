ACTIVE = "#"
INACTIVE = "."
DIRECTIONS = [-1, 0, 1]
ALL_DIRECTIONS = DIRECTIONS.product(DIRECTIONS, DIRECTIONS) - [[0,0,0]]
PART2_DIRECTIONS = DIRECTIONS.product(DIRECTIONS, DIRECTIONS, DIRECTIONS) - [[0,0,0,0]]

def example_data
<<-EXAMPLE
.#.
..#
###
EXAMPLE
end


def parse_data(data)
  map = {}
  z = 0
  data.split("\n").each_with_index do |line, y|
    line.chars.each_with_index do |value, x|
      map[[x-1,y-1,z]] = value
    end
  end
  map
end


def part1(data, cycles)
  map = parse_data(data)

  cycles.times do
    new_map = map.dup
    (-12..12).to_a.each do |z|
      (-12..12).to_a.each do |y|
        (-12..12).to_a.each do |x|
          position = [x,y,z]
          value = map[position]
          new_value = calculate_step(map, position, value)
          new_map[position] = new_value
        end
      end
    end
    map = new_map
  end

  # (-1..1).to_a.each do |z|
  #   puts "z=#{z}"
  #   (-1..1).to_a.each do |y|
  #     (-1..1).to_a.each do |x|
  #       print map[[x,y,z]]
  #     end
  #     puts "\n"
  #   end
  #   puts "\n"
  # end

  map.values.count("#")
end


def calculate_step(map, position, value)
  x,y,z = position

  neighbour_positions = ALL_DIRECTIONS.map do |offset_x, offset_y, offset_z|
    [x + offset_x, y + offset_y, z + offset_z]
  end


  neighbours = neighbour_positions.map do |p|
    map[p]
  end

  # If a cube is active and exactly 2 or 3 of its neighbors are also active, 
  # the cube remains active. Otherwise, the cube becomes inactive.
  if value == ACTIVE
    if neighbours.count(ACTIVE) == 2 || neighbours.count(ACTIVE) == 3
      return ACTIVE
    else
      return INACTIVE
    end
  end
  
  # If a cube is inactive but exactly 3 of its neighbors are active,
  # the cube becomes active. Otherwise, the cube remains inactive.
  if value == INACTIVE || value.nil?
    if neighbours.count(ACTIVE) == 3
      return ACTIVE
    else
      return INACTIVE
    end
  end
end












def parse_data_part2(data)
  map = {}
  z = 0
  w = 0
  data.split("\n").each_with_index do |line, y|
    line.chars.each_with_index do |value, x|
      map[[x-1,y-1,z,w]] = value
    end
  end
  map
end




def part2(data, cycles)
  map = parse_data_part2(data)

  cycles.times do
    puts "Starting new cycle"
    new_map = map.dup
    (-12..12).to_a.each do |w|
      (-12..12).to_a.each do |z|
        (-12..12).to_a.each do |y|
          (-12..12).to_a.each do |x|
            position = [x,y,z,w]
            value = map[position]
            new_value = calculate_step_part2(map, position, value)
            new_map[position] = new_value
          end
        end
      end
    end
    map = new_map
  end

  map.values.count("#")
end



def calculate_step_part2(map, position, value)
  x,y,z,w = position

  neighbour_positions = PART2_DIRECTIONS.map do |offset_x, offset_y, offset_z, offset_w|
    [x + offset_x, y + offset_y, z + offset_z, w + offset_w]
  end

  neighbours = neighbour_positions.map do |p|
    map[p]
  end

  # If a cube is active and exactly 2 or 3 of its neighbors are also active, 
  # the cube remains active. Otherwise, the cube becomes inactive.
  if value == ACTIVE
    if neighbours.count(ACTIVE) == 2 || neighbours.count(ACTIVE) == 3
      return ACTIVE
    else
      return INACTIVE
    end
  end
  
  # If a cube is inactive but exactly 3 of its neighbors are active,
  # the cube becomes active. Otherwise, the cube remains inactive.
  if value == INACTIVE || value.nil?
    if neighbours.count(ACTIVE) == 3
      return ACTIVE
    else
      return INACTIVE
    end
  end
end



if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    # def test_part1
    #   assert_equal(5,   part1(example_data, 0))
    #   assert_equal(11,  part1(example_data, 1))
    #   assert_equal(21,  part1(example_data, 2))
    #   assert_equal(38,  part1(example_data, 3))
    #   assert_equal(112, part1(example_data, 6))
    # end

    def test_part2
      assert_equal(848, part2(example_data, 6))
    end
  end
end


data = File.read('17_input')

# puts "Part 1: #{part1(data, 6)}"
puts "Part 2: #{part2(data, 6)}"
# part1(example_data, 1)