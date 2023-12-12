# watch -c "rspec 10_code.rb --force-color"

example =  File.readlines('10_example').map(&:chomp)
example2 = File.readlines('10_example2').map(&:chomp)
input = File.readlines('10_input').map(&:chomp)




def part1(input)
  pipe_map = {
    "|" => [:up, :down],
    "-" => [:left, :right],
    "L" => [:up, :right],
    "J" => [:up, :left],
    "7" => [:down, :left],
    "F" => [:down, :right]
  }
  
  
  # Find start coordinates
  starty = 0
  startx = 0

  input.each.with_index do |line, index|
    if line.index("S")
      starty = index
      startx = line.index("S")
    end
  end

  puts "starty: #{starty}  startx: #{startx}"


  paths = find_adjacents(starty, startx, input[0].size).map do |pos|
    {steps: 1, pos: pos, prev: [starty, startx]}
  end


  loopcount = 0
  loop do
    loopcount += 1

    paths.each_with_index do |path, i|

      # puts "\n\nChecking path: #{path}"
      # Find out where do we come from: down, up, left or right
      y = path[:pos][0]
      x = path[:pos][1]
      pipe = input[y][x]
      from_direction = find_direction(path[:prev], path[:pos])
      allowed_directions = pipe_map[pipe]

      # puts "position #{y} #{x} (#{pipe}), coming from #{from_direction}, allowed_directions #{allowed_directions}"


      # Check if the current pipe allows that connection. Else remove the path
      if allowed_directions.nil? || !allowed_directions.include?(from_direction)
        # Broken pipe!
        paths.delete_at(i)
        puts "Deleting path, we are now left with #{paths.size} paths"
        next
      end

      # Check what the next connection should be
      to_direction = (allowed_directions - [from_direction])[0]
      new_position = calculate_next_position(y, x, to_direction)
      # puts "Moving from #{y}, #{x} to #{to_direction} direction. New position: #{new_position}"

      # Update the path
      path[:steps] += 1
      path[:prev] = path[:pos]
      path[:pos] = new_position
      

      # Check if the new_position is in some other path
      colliding_paths = paths.select{|p| p[:pos] == new_position}
      if colliding_paths.size == 2
        puts "Stopping as there are 2 paths colliding: #{colliding_paths}"
        return path[:steps]
        break
      end
    end

    break if paths.count == 0
    # break if loopcount > 5
  end


  # Find the 9 possible path starts
    # 2 of them will valid, the rest are not
    # At some point, 2 of them will connect. When this happens, I am done
    # paths = [{steps: 1, current_pos: [y,x], previous_pos: [y, x]}]

  # Iterate through the 4 paths
    # If I hit a wall, delete the path
    # If I hit a position which is already part of another path, stop the execution and print the number of steps

  # paths[0][:steps]
  # 4
end


def calculate_next_position(y, x, direction)
  case direction
  when :up
    y -= 1
  when :down
    y += 1
  when :left
    x -= 1
  when :right
    x += 1
  end

  [y, x]
end


def find_direction(from, to)
  if to[0] > from[0]
    :up
  elsif to[0] < from[0]
    :down
  elsif to[1] > from[1]
    :left
  elsif to[1] < from[1]
    :right
  else
    nil
  end
end



def find_adjacents(y, x, size)
  list = []

  # top
  list << [y-1, x] if y > 0

  # right and left
  list << [y, x-1] if x > 0
  list << [y, x+1] if x < size
  
  # bottom_row  
  list << [y+1, x] if y < size

  return list
end


# describe 'part1' do
#   it 'calculates part 1' do
#     expect(part1(example)).to eq 4
#     expect(part1(example2)).to eq 8
#   end
# end

puts part1(input)