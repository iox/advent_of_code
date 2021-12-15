


def calculate(grid)
  queue = []
  lowest_risks = Hash.new(1000000) # Initialize this with a big value

  # Fill the queue
  queue << [0,0]
  lowest_risks[[0, 0]] = 0


  loop do
    break if queue.size == 0
    
    y,x = queue.shift

    existing_risk = lowest_risks[[y,x]]

    [[-1,0], [0,-1],[0, 1], [1, 0]].each do |diff_x, diff_y|
      next_x = x + diff_x
      next_y = y + diff_y
      new_point = [next_y, next_x]
      # Check if the new point is out of bounds
      next if next_x < 0 || next_y < 0 || next_y >= grid.size || next_x >= grid[0].size
    
      new_risk = grid[next_y][next_x]

      if new_risk + existing_risk < lowest_risks[new_point]
        lowest_risks[new_point] = new_risk + existing_risk
        queue << new_point
      end    
    end
  end

  lowest_risks[[grid.size-1, grid.first.size-1]]
end



grid = File.readlines('15_input').map{|l| l.chomp.chars.map(&:to_i)}
# puts calculate(grid)



grid = grid.map.with_index do |line, y|
  new_line = line.dup

  4.times.with_index do |i|
    line.each do |value, x|
      new_value = value+i+1
      new_value = (new_value - 9) if new_value > 9
      new_line.push(new_value)
    end
  end
  new_line
end

new_grid = grid.dup
4.times.with_index do |i|
  grid.each do |line|
    new_line = line.dup
    new_line.map! do |value|
      new_value = value+i+1
      new_value = (new_value - 9) if new_value > 9
      new_value
    end
    new_grid.push(new_line)
  end
end

grid = new_grid




# grid.each do |line|
#   line.each do |value|
#     print value
#   end
#   print "\n"
# end


puts calculate(grid)



  # if risk > minimal_risk
  #   # puts "Risk was too high (#{risk})"
  #   next
  # end

  # # Check the values of the neigbours
  # down = grid[y+1] ? grid[y+1][x] : nil
  # right = grid[y][x+1]

  # if down.nil? && right.nil?
  #   puts "We have reached the end of this path: #{item.inspect}"
  #   if risk < minimal_risk
  #     puts "We have found a new minimal risk #{risk}"
  #     minimal_risk = risk
  #   end
  # end

  # if down
  #   risk_min_until_finish = risk + down + distance(grid,y+1,x)

  #   lowest_risk_recorded = lowest_risks[[y+1,x]] || 10000
  #   new_risk = risk+down

  #   if risk_min_until_finish < minimal_risk && lowest_risk_recorded > risk
  #     queue << [
  #       risk_min_until_finish*-1,
  #       new_risk,
  #       [y+1,x]
  #     ]
  #     lowest_risks[[y+1,x]] = new_risk
  #   end
    
    
  # end

  # if right
  #   risk_min_until_finish = risk + right + distance(grid,y,x+1)

  #   lowest_risk_recorded = lowest_risks[[y,x+1]] || 10000
  #   new_risk = risk+right

  #   if risk_min_until_finish < minimal_risk && lowest_risk_recorded > risk
  #     queue << [
  #       risk_min_until_finish*-1,
  #       new_risk,
  #       [y,x+1]
  #     ]
  #     lowest_risks[[y,x+1]] = new_risk
  #   end
  # end  

  # puts risk
    
# end



# puts minimal_risk