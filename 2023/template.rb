# watch -c "rspec 1_code.rb --force-color"

examples = File.readlines('1_example').map(&:chomp)
input = File.readlines('1_input').map(&:chomp)



def part1(input)
  input.each do |line|
    
  end
end


describe 'part1' do
  it 'calculates part 1' do
    expect(part1(examples)).to eq 21
  end
end

puts part1(input)