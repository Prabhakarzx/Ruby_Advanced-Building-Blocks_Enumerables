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

end