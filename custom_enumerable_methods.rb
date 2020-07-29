module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < self.size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    (i...self.size).my_each do |i|
      yield(self[i], i)
    end
  end

  def my_select
    result = []
    self.my_each { |i| result.push(i) if yield(i) }
    result
  end

  def my_all?
    result = true
    self.my_each { |i| false unless yield(i) }
    result
  end

  def my_any?
    result = false
    self.my_each { |i| false unless yield(i) }
    result
  end

  def my_none?
    result = true
    self.my_each do |i|
      result = false if self[i] == yield(i)
    end
    result
  end

  def my_count
    i = 0
    self.my_each { i += 1 }
    i
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    new_self = []
    my_each do |element|
      new_self << if is_a? Hash
                    yield(element[0], element[1])
                  else
                    yield(element)
                  end
    end
    new_self
  end

  def my_inject(initial = 0)
    i = 0
    accumulator = initial
    while i < self.length
      accumulator = yield(accumulator, self[i])
      i += 1
    end
    accumulator
  end

  def my_map_with_proc(&proc)
    return to_enum(:my_map_with_proc) unless block_given?

    new_self = []
    my_each do |element|
      new_self << if is_a? Hash
                    proc.call(element[0], element[1])
                  else
                    proc.call(element)
                  end
    end
    new_self
  end

  def my_map_with_proc_or_block(&proc)
    return to_enum(:my_map_with_proc_or_block) unless block_given?

    new_self = []
    my_each do |element|
      new_self << if is_a? Hash
                    (proc ? proc.call(element[0], element[1]) : yield(element[0], element[1]))
                  else
                    (proc ? proc.call(element) : yield(element))
                  end
    end
    new_self
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, num| product * num }
end

p multiply_els([2, 4, 5])
