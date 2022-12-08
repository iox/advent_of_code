grid = []

File.read('08_example').split("\n").each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    grid[y] ||= []
    grid[y][x] = char
  end
end


# Final grid is 100x100


# How many trees are visible from outside the grid?

puts grid.size
size = grid.size

count = 0

grid.each_with_index do |y_data, y|
  y_data.each_with_index do |height, x|    
    found = false

    # The corners are always visible
    
    if x == 0 || y == 0 || x == grid.size-1 || y == grid.size-1
      count += 1
      next
    end


    puts "#{x}, #{y} has height #{height}"

    # Check if visible from top
    new_x = x
    while new_x >= 0
      new_x +=1
      
    end
    

    # Check if visible from bottom


    # Check if visible from right

    # Check if visible from right


    # Iterate over the column
    # (0..size-1).to_a.each do |new_y|
    #   next if new_y == y

    #   if grid[new_y][x] >= height
    #     puts "#{x}, #{y} is visible!"
    #     count += 1
    #     found = true
    #     break
    #   end
    # end

    # next if found

    # # Iterate over the row
    # (0..size-1).to_a.each do |new_x|
    #   next if new_x == x

    #   if grid[y][new_x] >= height
    #     count += 1
    #     break
    #   end
    # end

  end
end

puts count