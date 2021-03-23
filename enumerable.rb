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
    my_all_flag = true
    if block_given?
      to_a.my_each do |item|
        return my_all_flag = false if item.nil? || item == false
        return my_all_flag = false unless yield item
      end
    elsif param
      if param.instance_of?(Class)
        my_each do |item|
          return my_all_flag = false if item.is_a?(param) == false
        end
      elsif param.instance_of?(Regexp)
        my_each do |item|
          return my_all_flag = false if param.match(item).nil?
        end
        # elsif !param.is_a?(Class) && !param.is_a?(Regexp)
        #   case param
        #     in self
        #       return true
        #   else
        #     return false
        #   end
      end
    else
      to_a.my_each do |item|
        return my_all_flag = false if item.nil? || item == false
      end
    end
    my_all_flag
  end

  def my_any?(param = nil)
    if block_given?
      my_any_flag = []
      to_a.my_each { |item| my_any_flag.push(item) if yield item }
      my_any_flag.empty? ? false : true
    elsif param
      my_any_flag = []
      if param.instance_of?(Class)
        my_each do |item|
          my_any_flag.push(item) if item.is_a?(param) == true
        end
        if my_any_flag.empty?
          false
        else
          true
        end
      elsif param.instance_of?(Regexp)
        my_each do |item|
          my_any_flag.push(item) unless param.match(item).nil?
        end
        if my_any_flag.empty?
          false
        else
          true
        end
        # elsif !param.is_a?(Class) && !param.is_a?(Regexp)
        # case param
        # in self
        # return true
        #  else
        # return false
        # end
      end
    else
      my_any_flag = true
      to_a.my_each do |item|
        return my_any_flag if item.nil? || item == false
      end
      my_any_flag = false
    end
  end

  def my_none?(param = nil)
    if block_given?
      my_none_flag = []
      to_a.my_each { |item| my_none_flag.push(item) if yield item }
      my_none_flag.empty? ? true : false
    elsif param
      my_none_flag = true
      if param.instance_of?(Regexp)
        my_each do |item|
          return my_none_flag = false unless param.match(item).nil?
        end
        my_none_flag
      elsif param.instance_of?(Class)
        my_each do |item|
          return my_none_flag = false if item.is_a?(param) != false
        end
        my_none_flag
        #   elsif !param.is_a?(Class) && !param.is_a?(Regexp)
        #   case param
        #     in self
        #       return flase
        #   else
        #     return true
        #   end
      end
    else
      my_none_flag = []
      to_a.my_each do |item|
        my_none_flag.push(item) if !item.nil? && item != false
      end
      if my_none_flag.empty?
        true
      else
        false
      end
    end
  end

  def my_count(param = nil)
    if block_given?
      result = to_a.my_select { |item| item }
      result.length
    elsif param
      result = to_a.my_select { |item| item == param }.length
      result
    else
      to_a.length
    end
  end

  def my_map(param = nil)
    if block_given?
      result = []
      to_a.my_each { |item| result.push(yield item) }
      result
    elsif param && block_given?
      if param.is_a?(Proc) then to_a.my_each { |item| result.push(param.call(item)) }
      else
        my_any_flag = true
        to_a.my_each do |item|
          return my_any_flag if item.nil? || item == false
        end
        my_any_flag = false
      end
    end
  end

  def my_inject(param = nil, symbol_value = nil)
    new_array = []
    to_a.my_each { |item| new_array.push(item) }
    if param && symbol_value.nil?
      if param.is_a? Symbol
        accumulator = to_a[0]
        new_array.shift
        new_array.my_each { |item| accumulator = accumulator.send(param.to_s, item) }
        accumulator
      elsif block_given?
        accumulator = param
        new_array.my_each { |item| accumulator = yield(accumulator, item) }
        accumulator
      end
    elsif param && symbol_value
      if symbol_value.is_a? Symbol
        accumulator = param
        new_array.my_each { |item| accumulator = accumulator.send(symbol_value.to_s, item) }
        accumulator
      end
    elsif block_given?
      accumulator = to_a[0]
      new_array.shift
      new_array.my_each { |item| accumulator = yield(accumulator, item) }
      accumulator
    end
  end
end

def multiply_els(array)
  array.my_inject { |accumulator, item| accumulator * item }
end
