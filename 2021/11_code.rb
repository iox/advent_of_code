grid = File.readlines('11_input').map{|line| line.chomp.chars.map(&:to_i)}


total = 0
2000.times do |time_index|
  queue = []
  flashed = []

  # Increase by 1
  grid.each_with_index do |row, y|
    row.each_with_index do |value, x|

      grid[y][x] += 1
      if grid[y][x] > 9
        flashed << [y,x]
        queue << [y,x]
      end
    end
  end


  # Flashing queue
  loop do
    break if queue.size == 0
    y,x = queue.shift
    diffs = [
      [-1,-1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1,-1], [1, 0],[1, 1]
    ]
    
    diffs.each do |neighbour|
      diff_y,diff_x = neighbour
      point_y = y+diff_y
      point_x = x+diff_x
      next if point_y < 0 || point_x < 0
      next if grid[point_y].nil? || grid[point_y][point_x].nil?
      grid[point_y][point_x] += 1
      if grid[point_y][point_x] > 9
        queue << [point_y,point_x] unless flashed.include?([point_y, point_x])
        flashed << [point_y,point_x]
      end
    end
      

  end


  # Reset values to 0
  flashed.each do |flash|
    y,x = flash
    grid[y][x] = 0
  end


  # Debug print
  grid.each_with_index do |row, y|
    row.each_with_index do |value, x|
      if flashed.include?([y,x])
        print "\033[31m#{value}\033[0m"
      else
        print value
      end
    end
    print "\n"
  end
  print "\n\nSTEP #{time_index+1} IS FINISHED, #{flashed.uniq.size} flashes -----------\n\n\n"
  break if flashed.uniq.size == 100

  total += flashed.uniq.size
end

puts total