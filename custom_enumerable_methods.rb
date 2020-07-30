module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for element in self
      yield(element)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    my_self = self
    i = 0
    element = 0
    my_self.my_each do
      yield(element, i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_self = self
    my_self.my_each { |i| result.push(i) if yield(i) }
    result
  end

  def my_all?(*arg)
    result = true
    if !arg[0].nil?
      my_each { |i| result = false unless arg[0] == i }
    elsif !block_given?
      my_each { |i| result = false unless i }
    else
      my_each { |i| result = false unless yield(i) }
    end
    result
  end

  def my_any?(*arg)
    result = false
    if !arg[0].nil?
      my_each { |i| result = true if arg[0] == i }
    elsif !block_given?
      my_each { |item| result = true if item }
    else
      my_each { |item| result = true if yield(item) }
    end
    result
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(elem = nil)
    counter = 0

    if block_given?
      my_each { |item| counter += 1 if yield(item) }
    elsif elem
      my_each { |item| counter += 1 if item == elem }
    else
      counter = size
    end
    counter
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

    result = []
    if proc.nil?
      my_each { |item| result << yield(item) }
    else
      my_each { |item| result << proc.call(item) }
    end
    result
  end

  def my_inject(*arg)
    result = nil
    operation = nil

    if arg.length == 2
      result = arg[0]
      operation = arg[1]
      my_each do |element|
        result = result.send(operation, element)
      end
    elsif arg[0].is_a? Symbol
      operation = arg[0]
      my_each do |element|
        result = (result ? result.send(operation, element) : element)
      end
    else
      result = arg[0]
      my_each do |element|
        result = (result ? yield(result, element) : element)
      end
    end
    result
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, num| product * num }
end

p multiply_els([2, 4, 5])
