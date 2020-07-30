module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    my_self = self
    i = 0
    while i < my_self.size
      yield(my_self[i])
      i += 1
    end
    my_self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    for element in self
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
      my_each { |i| result = false unless arg[0] === i } # rubocop:disable Style/CaseEquality
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
      my_each { |i| result = true if arg[0] === i } 
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
    final_value = nil
    operation = nil

    if arg.length == 2
      final_value = arg[0]
      operation = arg[1]
      my_each do |element|
        final_value = final_value.send(operation, element)
      end
    elsif arg[0].is_a? Symbol
      operation = arg[0]
      my_each do |element|
        final_value = (final_value ? final_value.send(operation, element) : element)
      end
    else
      final_value = arg[0]
      my_each do |element|
        final_value = (final_value ? yield(final_value, element) : element)
      end
    end

    final_value
  end

end
 
array = [5, 4, 4, 0, 5, 0, 3, 4, 0, 0, 2, 6, 5, 6, 5, 6, 2, 1, 3, 0, 8, 0, 0, 1, 7, 1, 3, 5, 6, 1, 1, 1, 6, 5, 7, 7, 2, 0, 3, 1, 7, 0, 1, 4, 5, 7, 6, 5, 4, 3, 6, 5, 4, 0, 6, 2, 7, 2, 5, 6, 4, 7, 1, 3, 6, 3, 3, 2, 6, 1, 7, 7, 8, 6, 1, 3, 5, 0, 4, 1, 0, 5, 4, 2, 5, 2, 5, 6, 6, 0, 1, 8, 4, 5, 4, 0, 4, 0, 8, 6]

def multiply_els(arr)
  arr.my_inject(1) { |product, num| product * num }
end

p multiply_els([2, 4, 5,10]) 
