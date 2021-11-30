# The result!
  # I need to find those whose corner pattern is unique across all the possible patterns


def parse_patterns(data)
  tiles = {}
  data.split("\n\n").each do |block|
    id = block.match(/Tile (\d+)/)&.captures&.first&.to_i

    lines = block.split(":\n")[1].split("\n")

    top_line = lines.first
    bottom_line = lines.last
    right_line = ""
    left_line = ""
    lines.each do |line|
      left_line += line.chars.first
      right_line += line.chars.last
    end

    tiles[id] = [top_line, top_line.reverse, bottom_line, bottom_line.reverse, right_line, right_line.reverse, left_line, left_line.reverse].uniq    
  end
  tiles
end



def part1(data)
  tiles = parse_patterns(data)

  courner_ids = []

  tiles.each do |id, patterns|
    counter = 0

    patterns.each do |pattern|
      if tiles.values.flatten.count(pattern) > 1
        counter += 1
      end
    end

    puts "Tile #{id} has #{counter} common patterns"

    if counter == 4
      courner_ids << id
    end
  end

  courner_ids.reduce(:*)
end





def example_data
  File.read('20_example_input')
end

def data
  File.read('20_input')
end




if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal(20899048083289, part1(example_data))
    end
  end
else

  puts "Part 1: #{part1(data)}"
  # puts "Part 2: #{part2(data)}"

end
  
