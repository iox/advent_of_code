class Intcode

  attr_accessor :memory, :pointer, :status, :name, :output

  def initialize(memory:, name: 'IntCode Runner')
    @name = name
    @memory = memory
    @pointer = 0
    @status = 'initialized' # Possible statuses: initialized, running, waiting_for_input, paused, finished
    @output = nil
  end

  INTCODES = {
    99 => 'finish',
    1 => 'sum',
    2 => 'multiply',
    3 => 'wait_for_input',
    4 => 'print_output',
    5 => 'jump_if_true',
    6 => 'jump_if_false',
    7 => 'less_than',
    8 => 'equals'
  }

  DEBUG = true

  def run
    executed_instructions_counter = 0
    @status = 'running'

    while @status == 'running' do
      raise "INSTRUCTION NOT FOUND" unless INTCODES[next_instruction]
      # puts "#{INTCODES[next_instruction]}, #{next_attributes}" if DEBUG

      self.send(INTCODES[next_instruction], next_attributes)

      @pointer -= @pointer.size if @pointer > @memory.size

      executed_instructions_counter += 1
    end

    puts "#{@name} has stopped with status: '#{@status}' and output #{@output}. #{executed_instructions_counter} instructions have been executed" if DEBUG

    return @output
  end


  def enter_input(input_value)
    raise "PROGRAM #{@name} WAS NOT WAITING FOR INPUT (#{@status})" unless @status == 'waiting_for_input'

    @memory[next_attributes[:first_pointer]] = input_value
    @pointer += 2

    run
  end



  private


  def next_instruction
    if @memory[@pointer] > 99
      return @memory[@pointer].digits.first
    else
      return @memory[@pointer]
    end
  end


  def next_attributes
    if @memory[@pointer] > 99
      modes = @memory[@pointer].digits.drop(2)
    else
      modes = [0, 0, 0, 0]
    end

    {
      first_pointer: modes[0] && modes[0] == 1 ? (@pointer + 1) : @memory[@pointer + 1],
      second_pointer: modes[1] && modes[1] == 1 ? (@pointer + 2) : @memory[@pointer + 2],
      third_pointer: modes[2] && modes[2] == 1 ? (@pointer + 3) : @memory[@pointer + 3]
    }
  end

  def finish(first_pointer:, second_pointer:, third_pointer:)
    @status = 'finished'
  end

  def sum(first_pointer:, second_pointer:, third_pointer:)
    @memory[third_pointer] = @memory[first_pointer] + @memory[second_pointer]
    @pointer += 4
  end

  def multiply(first_pointer:, second_pointer:, third_pointer:)
    @memory[third_pointer] = @memory[first_pointer] * @memory[second_pointer]
    @pointer += 4
  end

  def wait_for_input(first_pointer:, second_pointer:, third_pointer:)
    @status = 'waiting_for_input'
  end

  def print_output(first_pointer:, second_pointer:, third_pointer:)
    @output = @memory[first_pointer]
    @status = 'paused'
    @pointer += 2
  end

  def jump_if_true(first_pointer:, second_pointer:, third_pointer:)
    if @memory[first_pointer] != 0
      @pointer = @memory[second_pointer]
    else
      @pointer += 3
    end
  end

  def jump_if_false(first_pointer:, second_pointer:, third_pointer:)
    if @memory[first_pointer] == 0
      @pointer = @memory[second_pointer]
    else
      @pointer += 3
    end
  end

  def less_than(first_pointer:, second_pointer:, third_pointer:)
    if @memory[first_pointer] < @memory[second_pointer]
      @memory[third_pointer] = 1
    else
      @memory[third_pointer] = 0
    end
    @pointer += 4
  end

  def equals(first_pointer:, second_pointer:, third_pointer:)
    if @memory[first_pointer] == @memory[second_pointer]
      @memory[third_pointer] = 1
    else
      @memory[third_pointer] = 0
    end
    @pointer += 4
  end

end
