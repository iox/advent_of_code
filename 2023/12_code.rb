# watch -c "rspec 12_code.rb --force-color"

examples = File.readlines('12_example').map(&:chomp)
input = File.readlines('12_input').map(&:chomp)


def possible_arrangements(line)
  count = 0
  springs = line.split(" ")[0]
  expected_groups = line.split(" ")[1].split(',').map(&:to_i)

  # This function returns all possible permutations
  permutations = find_permutations(springs)
  # puts "permutations.size: #{permutations.size}"

  permutations.each do |permutation|
    # Then, through each permutation, we calculate the groups and compare with the provided arrangement
    groups = find_groups(permutation)
    if groups == expected_groups
      # puts "Valid: #{permutation}"
      count += 1
    end
  end

  count
end






def find_groups(line)
  groups = []
  previous_char = "."

  line.chars.each do |char|
    if char == "#"
      if previous_char == "#"
        groups[-1] = groups.last + 1
      else
        groups << 1
      end
    end
    previous_char = char
  end

  groups
end


def find_permutations(string)
  occurrences = string.count('?')
  ['#','.'].repeated_permutation(occurrences).map do |replacement|
    temp_string = string.dup
    replacement.each do |char|
      temp_string.sub!('?', char)
    end
    temp_string
  end
end


def part1(input)
  sum = 0
  input.each.with_index do |line, index|
    # puts "line #{index}"
    sum += possible_arrangements(line)
  end
  sum
end


describe 'possible_arrangements' do
  it 'calculates possible arrangements' do
    expect(possible_arrangements("? 1")).to eq 1
    expect(possible_arrangements("?? 1")).to eq 2
    expect(possible_arrangements("?? 2")).to eq 1
    expect(possible_arrangements("?.? 1,1")).to eq 1
    expect(possible_arrangements("#.? 1,1")).to eq 1
    expect(possible_arrangements("???.### 1,1,3")).to eq 1
    expect(possible_arrangements(".??..??...?##. 1,1,3")).to eq 4
    expect(possible_arrangements("?#?#?#?#?#?#?#? 1,3,1,6")).to eq 1
    expect(possible_arrangements("????.#...#... 4,1,1")).to eq 1
    expect(possible_arrangements("????.######..#####. 1,6,5")).to eq 4
    expect(possible_arrangements("?###???????? 3,2,1")).to eq 10
  end
end

describe 'find_groups' do
  it 'finds groups in a string' do
    expect(find_groups("#")).to eq [1]
    expect(find_groups("#..##")).to eq [1,2]
    expect(find_groups("##..##")).to eq [2,2]
    expect(find_groups(".###.##...#.")).to eq [3,2,1]
  end
end


describe 'part1' do
  it 'calculates part 1' do
    expect(part1(examples)).to eq 21
  end
end

# puts part1(input)









#################





def fast_arrangements(line)
  springs = line.split(" ")[0]
  groups = line.split(" ")[1].split(',').map(&:to_i)

  memory = {}
  calculate(springs, groups, memory)
end




def calculate(springs, groups, memory)
  # Use the memory cache if available!
  if memory[[springs, groups]]
    return memory[[springs, groups]]
  end

  count = 0

  first_letter = springs[0]
  rest = springs.slice(1..-1)

  # We have found an unknown string
  if first_letter == "?"
    count += calculate("##{rest}", groups, memory)
    count += calculate(".#{rest}", groups, memory)
  end

  # We have found a working spring, ignore and continue
  if first_letter == "."
    count += calculate(rest, groups, memory)
  end

  # We have found a broken spring, modify groups and continue
  if first_letter == "#" && groups.size > 0
    new_groups = groups.dup
    first_group = groups[0]
    if first_group == 1
      new_groups.shift
      # When we remove a group, we need to make sure that the next character is a working spring
      if rest[0] == "#"
        return 0
      else
        rest[0] = "." if rest[0]
      end
    else
      # When we reduce the size of a group, we need to make sure the next character is a broken spring
      new_groups[0] = new_groups[0] - 1
      if rest[0] == "."
        return 0
      else
        rest[0] = "#" if rest[0]
      end
    end

    count += calculate(rest, new_groups, memory)
  end

  if first_letter == nil && groups == []
    count = 1
  end


  # Fill the memory cache before returning
  memory[[springs, groups]] = count

  # if count > 0 && springs.size > 0 && groups.size > 0
  #   verification_input = "#{springs} #{groups.join(',')}"
  #   # puts "verification_input: #{verification_input}"
  #   verification = possible_arrangements(verification_input)
  #   if verification != count
  #     puts "  "*(caller.length - 28) + "-- Calculated #{count} for springs: '#{springs}' and groups: #{groups}\n"
  #     raise "STOP!"
  #   end
    
  # end

  return count
end




describe 'fast_arrangements' do
  it 'calculates fast_arrangements' do
    expect(fast_arrangements("? 1")).to eq 1
    expect(fast_arrangements("...# 1")).to eq 1
    expect(fast_arrangements("?? 1")).to eq 2
    expect(fast_arrangements("?? 2")).to eq 1
    expect(fast_arrangements("?.? 1,1")).to eq 1
    expect(fast_arrangements("#.? 1,1")).to eq 1

    expect(fast_arrangements("#?? 1,1")).to eq 1

    expect(fast_arrangements("#?.? 1,1")).to eq 1
    

    expect(possible_arrangements("?#.?? 1,1")).to eq 2
    expect(fast_arrangements(    "?#.?? 1,1")).to eq 2
    
    
    expect(fast_arrangements("???.### 1,1,3")).to eq 1
    expect(fast_arrangements(".??..??...?##. 1,1,3")).to eq 4


    expect(possible_arrangements("?#?#?#?#?#?#?#? 1,3,1,6")).to eq 1
    expect(fast_arrangements(    "?#?#?#?#?#?#?#? 1,3,1,6")).to eq 1



    expect(fast_arrangements("????.#...#... 4,1,1")).to eq 1
    expect(fast_arrangements("????.######..#####. 1,6,5")).to eq 4

    expect(possible_arrangements("#??? 2,1")).to eq 1
    expect(fast_arrangements("#??? 2,1")).to eq 1

    expect(possible_arrangements("???? 1,1")).to eq 3

    expect(possible_arrangements("#???? 2,1")).to eq 2
    expect(fast_arrangements(    "#???? 2,1")).to eq 2

    expect(possible_arrangements("#????? 2,1")).to eq 3
    expect(fast_arrangements(    "#????? 2,1")).to eq 3

    expect(possible_arrangements("#???????? 2,1")).to eq 6
    expect(fast_arrangements(    "#???????? 2,1")).to eq 6

    expect(possible_arrangements("?###???????? 3,2,1")).to eq 10
    expect(fast_arrangements("?###???????? 3,2,1")).to eq 10



    expect(fast_arrangements(unfold("???.### 1,1,3"))).to eq 1
    expect(fast_arrangements(unfold(".??..??...?##. 1,1,3"))).to eq 16384
    expect(fast_arrangements(unfold("?#?#?#?#?#?#?#? 1,3,1,6"))).to eq 1
    expect(fast_arrangements(unfold("????.#...#... 4,1,1"))).to eq 16
    expect(fast_arrangements(unfold("????.######..#####. 1,6,5"))).to eq 2500
    expect(fast_arrangements(unfold("?###???????? 3,2,1"))).to eq 506250

  end
end










def unfold(line)
  springs = line.split(" ")[0]
  expected_groups = line.split(" ")[1]

  Array.new(5, springs).join("?") + " " + Array.new(5, expected_groups).join(",")
end



describe 'unfold' do
  it 'unfolds a line' do
    expect(unfold(".# 1")).to eq ".#?.#?.#?.#?.# 1,1,1,1,1"
    expect(unfold("???.### 1,1,3")).to eq "???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3"
  end
end



describe 'part2' do
  it 'calculates part 2' do
    expect(part2(examples)).to eq 525152
  end
end


def part2(input)
  sum = 0
  input.each.with_index do |line, index|
    sum += fast_arrangements(unfold(line))
  end
  sum
end


# puts part2(input)