#https://gist.github.com/PaulSanchez/a68e2b40af587dc968615f73c446e1e5
class PriorityQueue
  attr_reader :elements

  def initialize
    @elements = [nil]
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def pop
    exchange(1, @elements.size - 1)
    max = @elements.pop
    bubble_down(1)
    max
  end

  private

  def bubble_up(index)
    parent_index = (index / 2)

    return if index <= 1
    return if @elements[parent_index][0] >= @elements[index][0]

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = (index * 2)

    return if child_index > @elements.size - 1

    not_the_last_element = child_index < @elements.size - 1
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]
    child_index += 1 if not_the_last_element && right_element[0] > left_element[0]

    return if @elements[index][0] >= @elements[child_index][0]

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end














grid = File.readlines('15_input').map{|l| l.chomp.chars.map(&:to_i)}



# Make a first run
minimal_risk = 600
# total_steps = grid.size + grid.first.size - 2


queue = PriorityQueue.new
# min_risk_until_finish, risk, start
queue << [0, 0, [0,0]]


def distance(grid,y,x)
  grid.size + grid.first.size - x - y
end


lowest_risks = {}


index = 0
loop do
  index += 1
  
  item = queue.pop

  break if item.nil?

  if index % 100000 == 0
    puts "#{index} loops. #{item.inspect}. Current minimum #{minimal_risk}. Queue size #{queue.elements.size}"
  end

  y,x = item[2]
  risk = item[1]

  if risk > minimal_risk
    # puts "Risk was too high (#{risk})"
    next
  end

  # Check the values of the neigbours
  down = grid[y+1] ? grid[y+1][x] : nil
  right = grid[y][x+1]

  if down.nil? && right.nil?
    puts "We have reached the end of this path: #{item.inspect}"
    if risk < minimal_risk
      puts "We have found a new minimal risk #{risk}"
      minimal_risk = risk
    end
  end

  if down
    risk_min_until_finish = risk + down + distance(grid,y+1,x)

    lowest_risk_recorded = lowest_risks[[y+1,x]] || 10000
    new_risk = risk+down

    if risk_min_until_finish < minimal_risk && lowest_risk_recorded > risk
      queue << [
        risk_min_until_finish,
        new_risk,
        [y+1,x]
      ]
      lowest_risks[[y+1,x]] = new_risk
    end
    
    
  end

  if right
    risk_min_until_finish = risk + right + distance(grid,y,x+1)

    lowest_risk_recorded = lowest_risks[[y,x+1]] || 10000
    new_risk = risk+right

    if risk_min_until_finish < minimal_risk && lowest_risk_recorded > risk
      queue << [
        risk_min_until_finish,
        new_risk,
        [y,x+1]
      ]
      lowest_risks[[y,x+1]] = new_risk
    end
  end  

  # puts risk
    
end



puts minimal_risk