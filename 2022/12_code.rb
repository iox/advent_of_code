# Parse the input into an XY grid, converting each letter into a number
# While doing this, store the start and end positions


# I need an effort hash, initialized with an infinite value
# {
#   [0,0] => 0,
#   [1,1] => 10000000,
#   [0,1] => 10000000
# }

# Create an empty queue, by default it only contains the current position: [0/0]

# Loop!
  # - take the last item from the queue
  # - find all possible paths from here and the effort to get there (my effort + 1)
  #    - If the effort is less, reduce the effort to get to that slot and add them to the queue

dictionary = ("a".."z").to_a
target = []
grid = {}
efforts = Hash.new(999999999)
queue = []

File.read('12_input').split("\n").each_with_index do |row, y|
  row.chars.each.with_index do |letter, x|
    if letter == "S"
      letter = "a"
      queue << [y,x]
      efforts[[y,x]] = 0
    elsif letter == "E"
      letter = "z"
      target = [y,x]
    end
    grid[[y, x]] = dictionary.index(letter)
  end
end

i = 0

loop do
  i+= 1
  puts "Loop #{i}, queue size #{queue.size}" if i % 50000 == 0

  break if queue.size == 0

  pos = queue.pop
  y = pos[0]
  x = pos[1]
  current_effort = efforts[pos]
  current_height = grid[pos]

  [[y-1,x], [y+1,x], [y, x-1], [y, x+1]].each do |next_pos|
    next_effort = efforts[next_pos]
    next_height = grid[next_pos]

    # We can't move to a non existent height, or to a height to tall from here
    next if next_height.nil? || next_height > (current_height + 1)

    # We don't care about the path if there was an easier way to reach the new place
    next if next_effort <= current_effort + 1

    # Update the effort hash
    efforts[next_pos] = current_effort + 1

    # Add the pos to the queue
    queue << next_pos
  end
end

puts efforts[target]


