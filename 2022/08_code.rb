grid = []

File.read('08_input').split("\n").each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    grid[y] ||= []
    grid[y][x] = char.to_i
  end
end

# How many trees are visible from outside the grid?
count = 0

grid.each_with_index do |y_data, y|
  y_data.each_with_index do |height, x|    
    # The corners are always visible    
    if x == 0 || y == 0 || x == grid.size-1 || y == grid.size-1
      count += 1
      next
    end

    points_on_top = (0..y-1).to_a.map{|new_y| grid[new_y][x]}
    if points_on_top.all?{|p| p < height }
      count += 1
      next
    end

    points_on_bottom = (y+1..(grid.size-1)).to_a.map{|new_y| grid[new_y][x]}
    if points_on_bottom.all?{|p| p < height }
      count += 1
      next
    end

    points_on_left = (0..x-1).to_a.map{|new_x| grid[y][new_x]}
    if points_on_left.all?{|p| p < height }
      count += 1
      next
    end

    points_on_right = (x+1..(grid.size-1)).to_a.map{|new_x| grid[y][new_x]}
    if points_on_right.all?{|p| p < height }
      count += 1
      next
    end
  end
end

puts count







scores = []

grid.each_with_index do |y_data, y|
  y_data.each_with_index do |height, x|
    # x = 2
    # y = 1
    # height = 5

    # Skip the corners, their score is always zero
    if x == 0 || y == 0 || x == grid.size-1 || y == grid.size-1
      next
    end

    top_score, bottom_score, left_score, right_score = 0,0,0,0

    points_on_top = (0..y-1).to_a.map{|new_y| grid[new_y][x]}
    points_on_top.each do |tree|
      if tree <= height
        top_score += 1
        break if tree == height
      else
        break
      end
    end
    # puts "points_on_top: #{points_on_top} => top_score #{top_score}"

    points_on_bottom = (y+1..(grid.size-1)).to_a.map{|new_y| grid[new_y][x]}
    points_on_bottom.each do |tree|
      if tree <= height
        bottom_score += 1
        break if tree == height
      else
        break
      end
    end
    # puts "points_on_bottom: #{points_on_bottom} => bottom_score #{bottom_score}"

    points_on_left = (0..x-1).to_a.map{|new_x| grid[y][new_x]}
    points_on_left.each do |tree|
      if tree <= height
        left_score += 1
        break if tree == height
      else
        break
      end
    end
    # puts "points_on_left: #{points_on_left} => left_score #{left_score}"

    points_on_right = (x+1..(grid.size-1)).to_a.map{|new_x| grid[y][new_x]}
    points_on_right.each do |tree|
      if tree <= height
        right_score += 1
        break if tree == height
      else
        break
      end
    end
    # puts "points_on_right: #{points_on_right} => right_score #{right_score}"

    scores << (top_score * bottom_score * left_score * right_score)
  end
end



puts scores.max
