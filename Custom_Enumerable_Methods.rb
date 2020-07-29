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

end