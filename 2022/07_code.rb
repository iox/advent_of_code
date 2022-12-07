instructions = File.read('07_input.txt').split("\n")

# TODO: Create a hash with all the files:
# filesystem = {
#   "/a/e/i" => 584,
#   "/a/f" => 29116
# }

filesystem = {}

pwd = "/"
total = 0

instructions.each do |instruction|

  # puts "#{pwd} --->  #{instruction}"
  if instruction == "$ cd /"
    pwd = "/"
    next
  elsif instruction == "$ cd .."
    pwd = "/" + pwd.split("/").reject(&:empty?)[0...-1].join("/")
    next
  elsif path = instruction.split("$ cd ")[1]
    pwd += "/" unless pwd[-1] == "/"
    pwd += path
    next
  end



  if matches = instruction.match(/(\d+) (\S+)/)
    puts "Adding #{matches[1].to_i} to #{total}. New total #{total+matches[1].to_i}"
    total += matches[1].to_i
    next if pwd == "/"

    # We ignore files in the root directory
    path = pwd
    puts "\n\nStarting a loop for #{pwd} and file #{instruction}"
    loop do
      filesystem[path] ||= 0
      filesystem[path] += matches[1].to_i
      path = "/" + path.split("/").reject(&:empty?)[0...-1].join("/")
      break if path == "/"
      puts "   Repeating with parent #{path}"
    end
  end
end



puts filesystem.values.select{|v| v <= 100000}.sum




remaining = 70000000 - total
need_to_free = 30000000 - remaining



puts total
puts remaining
puts need_to_free

puts filesystem.values.select{|v| v >= need_to_free}.min