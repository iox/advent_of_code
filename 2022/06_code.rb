def subroutine(datastream)
  datastream.size.times.with_index do |i|
    marker = datastream[i, 4]
    return (i+4) if marker.chars.uniq.size == 4
  end
end


raise "error" unless subroutine("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
raise "error" unless subroutine("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
raise "error" unless subroutine("nppdvjthqldpwncqszvftbrmjlhg") == 6
raise "error" unless subroutine("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
raise "error" unless subroutine("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11


puts subroutine(File.read('06_input'))





def subroutine2(datastream)
  datastream.size.times.with_index do |i|
    marker = datastream[i, 14]
    return (i+14) if marker.chars.uniq.size == 14
  end
end

raise "error" unless subroutine2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
raise "error" unless subroutine2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
raise "error" unless subroutine2("nppdvjthqldpwncqszvftbrmjlhg") == 23
raise "error" unless subroutine2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
raise "error" unless subroutine2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26


puts subroutine2(File.read('06_input'))