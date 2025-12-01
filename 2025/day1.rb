# watch -c "rspec day1.rb --force-color"

def part1(input)
  entries = input.split("\n").map(&:strip)
  pointer = 50
  visits_to_zero = 0
  entries.each do |instruction|
    direction = instruction[0]
    distance = instruction[1..-1].to_i
    distance.times do
      if direction == 'R'
        pointer += 1
        if pointer == 100
          pointer = 0
        end
      elsif direction == 'L'
        pointer -= 1
        if pointer == -1
          pointer = 99
        end
      end
    end

    if pointer == 0
      visits_to_zero += 1
    end
    
  end
  visits_to_zero
end



def part2(input)
  entries = input.split("\n").map(&:strip)
  pointer = 50
  visits_to_zero = 0
  entries.each do |instruction|
    direction = instruction[0]
    distance = instruction[1..-1].to_i
    distance.times do
      if direction == 'R'
        pointer += 1
        if pointer == 100
          pointer = 0
        end
      elsif direction == 'L'
        pointer -= 1
        if pointer == -1
          pointer = 99
        end
      end
      if pointer == 0
        visits_to_zero += 1
      end
    end
    
  end
  visits_to_zero
end




puts part1(File.read('day1.txt'))
puts part2(File.read('day1.txt'))



require 'rspec'
describe 'day1' do
  it 'solves part 1 and 2' do
    sample = <<-EOF
      L68
      L30
      R48
      L5
      R60
      L55
      L1
      L99
      R14
      L82
      EOF

    expect(part1(sample)).to eq(3)
    expect(part2(sample)).to eq(6)
  end
end
