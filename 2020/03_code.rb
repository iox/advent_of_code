lines = File.readlines('03_input').map(&:chomp)

def tree_counter(lines, down, right)
  height = lines.size
  width = lines.first.size

  x = 0
  y = 0

  counter = 0

  loop do
    y += down
    x += right
    x -= width if lines[y][x] == nil
    counter += 1 if lines[y][x] == "#"
    break if y >= height-1
  end

  return counter
end

puts "Part 1: We found #{tree_counter(lines,1,3)} trees"




slopes = [
  {right: 1, down: 1},
  {right: 3, down: 1},
  {right: 5, down: 1},
  {right: 7, down: 1},
  {right: 1, down: 2}
]

counter = 0

slopes.map do |slope|
  if counter == 0
    counter = tree_counter(lines, slope[:down], slope[:right])
  else
    counter = counter * tree_counter(lines, slope[:down], slope[:right])
  end
end

puts "Part 2: The value is #{counter}"