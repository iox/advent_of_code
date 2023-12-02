numbers = File.read('06_input').split(",").map(&:to_i)


def calc(age)
  list = [age]
  80.times do
    new_list = []
    list.each do |age|
      age -= 1
      if age == -1
        new_list += [6, 8]
      else
        new_list += [age]
      end
    end
    list = new_list
  end
  list.count
end




agemap = {}
(1..5).to_a.each do |age|
  agemap[age] = calc(age)
end

puts agemap.inspect

result = 0
numbers.each do |n|
  result += agemap[n]
end

puts result







# Part 2
fishcount = {}
numbers = File.read('06_input').split(',').map(&:to_i)
numbers.each do |fish|
  fishcount[fish] ||= 0
  fishcount[fish]+= 1
end

256.times do |i|
  newfishcount = Hash.new(0)
  fishcount.each do |age, number|
    if age == 0
      newfishcount[6] += number
      newfishcount[8] += number
    else
      newfishcount[age-1] += number
    end
  end
  fishcount = newfishcount
end

total = 0
fishcount.each do |age, number|
  total += number
end

puts total