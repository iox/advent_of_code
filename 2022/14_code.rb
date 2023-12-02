

def print_debug(grid)
  puts "\n\n"
  (0..12).to_a.each do |y|
    (485..525).to_a.each do |x|
      print grid[[y,x]]
    end
    print "\n"
  end
end


def drop_sand(grid, max_y = 9999999)
  y = 0
  x = 500
  loop_count = 0

  loop do
    loop_count += 1
    return "STOP" if y > 500

    moved = false
    

    new_positions = [[y+1, x], [y+1, x-1], [y+1, x+1]]

    new_pos = new_positions.find do |pos|
      is_empty = grid[pos] == "."
      is_empty
    end

    if y+1 == max_y
      break # We have reached the floor
    end

    if new_pos
      # puts "  The sand has moved to #{new_pos}, let's try another loop"
      y,x = new_pos
    else
      # The sand has stopped moving
      break
    end
  end
  
  if grid[[y,x]] == "." && y <= 500
    grid[[y,x]] = "o" 
  else
    return "STOP"
  end
  
end





grid = Hash.new(".")

File.read('14_input').split("\n").each do |line|
  line.split(" -> ").each_cons(2).each do |pair|
    x1,y1 = pair.first.split(",").map(&:to_i)
    x2,y2 = pair.last.split(",").map(&:to_i)

    x_range = x1 > x2 ? (x2..x1) : (x1..x2)
    y_range = y1 > y2 ? (y2..y1) : (y1..y2)

    x_range.to_a.each do |x|
      y_range.to_a.each do |y|
        grid[[y,x]] = "#"
      end
    end

  end
end

max_y = grid.keys.map(&:first).max + 2




units = 0
400000.times do
  result = drop_sand(grid, max_y)
  break if result == "STOP"
  units += 1
end
print_debug(grid)  

puts units