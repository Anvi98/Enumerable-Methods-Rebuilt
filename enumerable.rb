module Enumerable
  def my_each
    i = 0
    if block_given?
      while i < to_a.length
        yield to_a[i]
        i += 1
      end
      self
    else
      to_enum(:my_each)
    end
  end

  def my_each_with_index
    i = 0
    if block_given?
      while i < to_a.length
        yield(to_a[i], i)
        i += 1
      end
      self
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    new_items = []
    if block_given?
      to_a.my_each { |item| new_items.push(item) if yield item }
      new_items
    else
      to_enum(:my_select)
    end
  end

  def my_all?(param = nil) 
    if block_given?
      my_all_flag = true
      to_a.my_each do |item|
        if item == nil || item == false
          my_all_flag = false
          break
        elsif !yield item then my_all_flag = false
        end
        end
        my_all_flag     
    elsif param
      my_all_flag = true
      if param.instance_of?(Class)
        self.my_each do |item|
          if item.is_a?(param) == false
            my_all_flag = false
            break
          end
          end
        my_all_flag
      elsif param.instance_of?(Regexp)
        my_all_flag = true
        self.my_each do |item|
          if param.match(item) == nil
            my_all_flag = false
          break
          end
        end
        my_all_flag
      elsif !param.is_a?(Class) && !param.is_a?(Regexp)
        case param
          in self
            return true
        else
          return false
        end
      end
    else
      my_all_flag = true
      to_a.my_each do |item| 
        if item == nil || item == false
          return my_all_flag = false
          break
        end
      end
      my_all_flag
    end
  end

  def my_any?(param = nil)
    if block_given?
      my_any_flag = []
      to_a.my_each { |item| my_any_flag.push(item) if yield item }
      if my_any_flag.empty?
        false
      else
        true
      end
    elsif param
      my_any_flag = []
      if param.instance_of?(Class)
        self.my_each do |item|
        if item.is_a?(param) == true
          my_any_flag.push(item)
        end
       end
      if my_any_flag.empty?
        false
      else
        true
      end
    elsif param.instance_of?(Regexp)
      self.my_each do |item|
        if param.match(item) != nil
         my_any_flag.push(item)
        end
      end
      if my_any_flag.empty?
        false
      else
        true
      end
      elsif !param.is_a?(Class) && !param.is_a?(Regexp)
      case param
        in self
          return true
      else
        return false
      end
    end
    else
      my_any_flag = true
      to_a.my_each do |item|
        if item == nil || item == false
          return my_any_flag
          break
        end 
      end
      my_any_flag = false
    end
  end

  def my_inject(param = nil)
    new_array = to_a
    if param
      if param.is_a? Symbol
        accumulator = to_a[0]
        param = param.to_s
        
        p param
        new_array.my_each {|item, accumulator| accumulator = accumulator.send(param, item)}
        accumulator
      # else
      # accumulator = param
      end
  #   else
  #     accumulator = to_a[0]
  #     new_array.shift
  #   end
  #   new_array.my_each { |item| accumulator = yield(accumulator, item) }
  #   accumulator
  end
end

end

def multiply_els(array)
  array.my_inject { |accumulator, item| accumulator * item }
end

list = %w[Maha nil Alex]
number = [6, 4.5, 7]
hash = { foo: 0, bar: 1, baz: 2 }
k = {a:0, x:1}

#p %w[ant bear cat].my_all? { |word| word.length >= 3 }
#p %w[ant bear cat].my_all? { |word| word.length >= 4 }
#p %w[ant bear cat].my_all?(/t/)
#p [1, 2i, 3.14].my_all?(Numeric)
#p [nil, true, 99].my_all? 
#p [].my_all?
#p (5..10).my_inject(:+) 
#p %w[ant bear cat].my_any? { |word| word.length >= 3 }
#p %w[ant bear cat].my_any? { |word| word.length >= 4 }
#p %w[ant bear cat].my_any?(/d/)
#p [nil, true, 99].my_any?(Integer)
#p [nil, true, 99].my_any?
#p [].my_any?

p (5..10).my_inject(:+)
#p r.map {|o| 2.public_send o,2 }