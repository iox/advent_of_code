def example_data
<<-EXAMPLE
F10
N3
F7
R90
F11
EXAMPLE
end

def part1(data)
  instructions = data.split("\n")

  y = 0
  x = 0
  direction = :right

  instructions.each do |instruction|
    key = instruction.slice!(0)
    value = instruction.to_i
    
    case key
    when 'N'
      y += value
    when 'S'
      y -= value
    when 'E'
      x += value
    when 'W'
      x -= value
    when 'L'
      (value/90).times do
        case direction
        when :right
          direction = :up
        when :down
          direction = :right
        when :left
          direction = :down
        when :up
          direction = :left
        end
      end
    when 'R'
      (value/90).times do
        case direction
        when :right
          direction = :down
        when :down
          direction = :left
        when :left
          direction = :up
        when :up
          direction = :right
        end
      end
    when 'F'
      case direction
      when :right
        x += value
      when :down
        y -= value
      when :left
        x -= value
      when :up
        y += value
      end
    end


  end

  [y.abs, x.abs]
end






def part2(data)
  instructions = data.split("\n")

  y = 1
  x = 10
  boaty = 0
  boatx = 0

  instructions.each do |instruction|
    key = instruction.slice!(0)
    value = instruction.to_i
    
    case key
    when 'N'
      y += value
    when 'S'
      y -= value
    when 'E'
      x += value
    when 'W'
      x -= value
    when 'L'
      (value/90).times do
        newy = x.dup
        newx = y.dup * -1
        y = newy
        x = newx
      end
    when 'R'
      (value/90).times do
        newy = x.dup * -1
        newx = y.dup
        y = newy
        x = newx
      end
    when 'F'
      value.times do
        boatx += x
        boaty += y
      end
    end
  end

  [boaty.abs, boatx.abs]
end






if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal([8, 17], part1(example_data))

      assert_equal([72, 214], part2(example_data))
    end
  end

end

part2(example_data)
data = File.read('12_input')
puts "Part 1: #{part1(data).reduce(:+)}"
puts "Part 2: #{part2(data).reduce(:+)}"