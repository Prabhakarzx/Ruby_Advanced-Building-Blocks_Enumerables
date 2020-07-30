module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for element in self # rubocop:disable Style/For
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
  def my_all?(param = nil)
    if !block_given?
      my_all? { |element| param.nil? ? element : param === element } # rubocop:disable Style/CaseEquality
    elsif is_a? Hash
      count = 0
      my_each do |element|
        break unless yield(element[0], element[1])

        count += 1
      end
      count == size
    else
      count = 0
      my_each do |element|
        break unless yield(element)

        count += 1
      end
      count == size
    end
  end

  def my_any?(param = nil)
    if !block_given?
      my_any? { |element| param.nil? ? element : param === element } # rubocop:disable Style/CaseEquality
    elsif is_a? Hash
      my_each do |element|
        return true if yield(element[0], element[1])
      end
      false
    else
      my_each do |element|
        return true if yield(element)
      end
      false
    end
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
