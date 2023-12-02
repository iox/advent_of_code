# example = <<HERE
# ...>...
# .......
# ......>
# v.....>
# ......>
# .......
# ..vvv..
# HERE


example = <<HERE
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
HERE

grid = []

File.read('25_input').split("\n").each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    grid[y] ||= []
    grid[y][x] = char
  end
end

width = grid.first.size
height = grid.size


def render(grid)
  grid.each do |row|
    row.each do |char|
      print char
    end
    puts "\n"
  end
end


step = 1
loop do
  east_grid = Marshal.load(Marshal.dump(grid))

  # render(east_grid)

  grid.each_with_index do |row,y|
    row.each_with_index do |char,x|
      next if char == "."

      if char == ">"
        new_x = (x == width-1) ? 0 : x+1
        if grid[y][new_x] == "."
          east_grid[y][new_x] = ">"
          east_grid[y][x] = "."
        end
      end
    end
  end


  south_grid = Marshal.load(Marshal.dump(east_grid))

  east_grid.each_with_index do |row,y|
    row.each_with_index do |char,x|
      next if char == "."

      if char == "v"
        new_y = (y == height-1) ? 0 : y+1
        if east_grid[new_y][x] == "."
          south_grid[new_y][x] = "v"
          south_grid[y][x] = "."
        end
      end
    end
  end


  if grid == south_grid
    puts "\n\n\nFirst step when no cucumbers move: #{step}"
    break
  end

  puts "\nAfter #{step} step:"
  step += 1

  grid = south_grid
end