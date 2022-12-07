pairs = File.readlines('04_input').map{|p| p.split(",").map{|r| (r.split("-")[0].to_i)..(r.split("-")[1].to_i)}}

result = pairs.count do |pair|
  pair[0].cover?(pair[1]) || pair[1].cover?(pair[0])
end

puts result

result = pairs.count do |pair|
  !(pair[0].first > pair[1].last || pair[0].last < pair[1].first)
end

puts result