module Enumerable
  def my_each
    i = 0
    while i < self.size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    for i in i...self.size
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

end