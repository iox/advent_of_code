# positions = [16,1,2,0,4,2,7,1,2,14]
positions = File.read('07_input').split(',').map(&:to_i)

fuelmap = Hash.new

(0..800).to_a.each do |endpos|
  fuelcount = 0
  positions.each do |pos|
    fuelcount += (pos - endpos).abs
  end
  fuelmap[endpos] = fuelcount
end


puts fuelmap.min_by{|k, v| v}.inspect




fuelmap = Hash.new

(0..500).to_a.each do |endpos|
  fuelcount = 0
  positions.each do |pos|
    absolute = (pos - endpos).abs
    fuelcount += absolute * (absolute + 1) / 2
  end
  fuelmap[endpos] = fuelcount
end


puts fuelmap.min_by{|k, v| v}.inspect