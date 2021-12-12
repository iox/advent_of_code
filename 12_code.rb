example = <<HERE
start-A
start-b
A-c
A-b
b-d
A-end
b-end
HERE


example = <<HERE
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
HERE


example = <<HERE
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
HERE


real = <<HERE
DA-xn
KD-ut
gx-ll
dj-PW
xn-dj
ll-ut
xn-gx
dg-ak
DA-start
ut-gx
YM-ll
dj-DA
ll-xn
dj-YM
start-PW
dj-start
PW-gx
YM-gx
xn-ak
PW-ak
xn-PW
YM-end
end-ll
ak-end
ak-DA
HERE

connections = {}
real.lines.map(&:chomp).each do |l|
  origin = l.split('-')[0]
  dest = l.split('-')[1]
  connections[origin] ||= []
  connections[origin] << dest
  connections[dest] ||= []
  connections[dest] << origin
end
puts connections.inspect
puts "\n\n"






count = 0
queue = [["start"]]
valid_paths = []

loop do
  if valid_paths.size % 1000 == 0
    puts "Valid paths: #{valid_paths.size}, queue #{queue.size}"
  end
  break if queue.size == 0
  path = queue.shift

  next if connections[path.last].nil?

  connections[path.last].each do |connection|
    new_path = path.dup
    next if connection == "start"

    new_path << connection

    to_be_checked = new_path.select{|c| c == c.downcase && c != 'start'}.tally
    next if to_be_checked.values.count{|v| v>1} > 1
    next if to_be_checked.values.any?{|v| v>2}

    if connection == "end"
      valid_paths << new_path
    else
      # puts "Adding path #{new_path} to the queue"
      queue << new_path #unless queue.include?(new_path)
    end
  end
end

# puts "\n\nFINISH\n\n"
# valid_paths.uniq.sort.each do |path|
#   puts path.join(',')
# end




puts "\n\n#{valid_paths.uniq.size}"