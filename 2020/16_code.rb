data = File.read('16_input')


def example_data
<<-EXAMPLE
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
EXAMPLE
end


def parse_rules(data)
  rules = {}
  data.split("\n\n")[0].split("\n").each do |line|
    key = line.split(": ")[0].to_sym
    values = []
    line.split(": ")[1].split(" or ").map{|s| s.split("-").map(&:to_i)}.each do |numbers|
      values += (numbers[0]..numbers[1]).to_a
    end
    rules[key] = values
  end
  rules
end
        

def parse_nearby_tickets(data)
  tickets = []

  data.split("\n\n")[2].split("nearby tickets:\n")[1].split("\n").each do |line|
    tickets << line.split(",").map(&:to_i)
  end

  tickets
end

def parse_your_ticket(data)
  data.split("\n\n")[1].split("your ticket:\n")[1].split(",").map(&:to_i)
end



def part1(data)
  rules = parse_rules(data)
  nearby_tickets = parse_nearby_tickets(data)

  valid_numbers = rules.values.reduce(:+).uniq

  all_ticket_numbers = nearby_tickets.reduce(:+)

  all_ticket_numbers.select{|number| !valid_numbers.include?(number)}
end


def part2(data)
  rules = parse_rules(data)
  nearby_tickets = parse_nearby_tickets(data)
  your_ticket = parse_your_ticket(data)

  valid_numbers = rules.values.reduce(:+).uniq
  valid_nearby_tickets = nearby_tickets.select do |ticket|
    ticket.all?{|number| valid_numbers.include?(number)}
  end

  departure_indexes = []
  columns = []
  valid_nearby_tickets.first.size.times do
    columns << []
  end

  valid_nearby_tickets.each do |ticket|
    ticket.each_with_index do |value, index|
      columns[index] << value
    end
  end


  departure_indexes = []
  fields = (0..19).to_a

  loop do
    break if fields.size == 0

    rules.each do |key, valid_numbers|
      matching_fields = fields.select do |field_index|
        columns[field_index].all? do |value|
          valid_numbers.include?(value)
        end
      end

      if matching_fields.size == 1
        # puts "#{key} has index #{matching_fields.inspect}"
        if key.to_s.include?("departure")
          departure_indexes << matching_fields[0]
        end
        fields.delete(matching_fields[0])
        rules.delete(key)
      end
    end
  end

  your_departure_values = your_ticket.values_at(*departure_indexes)  
  your_departure_values.reduce(:*)
end


if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_parse_rules
      assert_equal([1,2,3,5,6,7], parse_rules(example_data)[:class])
    end

    def test_parse_nearby_tickets
      assert_equal([7,3,47], parse_nearby_tickets(example_data)[0])
    end

    def test_parse_your_ticket
      assert_equal([7,1,14], parse_your_ticket(example_data))
    end

    def test_part1
      assert_equal([4,55,12], part1(example_data))
    end
  end
end

parse_nearby_tickets(example_data)

puts "Part 1: #{part1(data).sum}"
puts "Part 2: #{part2(data)}"