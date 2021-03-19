module Enumerable
  def my_each
    i = 0
    if block_given?
      while i < to_a.length
        yield to_a[i]
        i += 1
      end
    end
    to_enum(:my_each)
  end

  def my_each_with_index
    i = 0
    if block_given?
      while i < to_a.length
        yield(to_a[i], i)
        i += 1
      end
    end
    to_enum(:my_each_with_index)
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

  def my_all?
    if block_given?
      my_all_flag = true
      to_a.my_each { |item| my_all_flag = false unless yield item }
      my_all_flag
    else
      true
    end
  end

  def my_any?
    if block_given?
      my_any_flag = []
      to_a.my_each { |item| my_any_flag.push(item) if yield item }
      flag_result = my_any_flag.empty?
      flag_result ? false : true
    else
      true
    end
  end

  def my_none?
    if block_given?
      my_none_flag = []
      to_a.my_each { |item| my_none_flag.push(item) if yield item }
      flag_result = my_none_flag.empty?
      flag_result ? true : false
    else
      false
    end
  end

  def my_count(param = nil)
    if block_given?
      if block_given?
        result = to_a.my_select do |item|
          yield item
        end
        result.length
    elsif !block_given? && param != nil?
      to_a.my_select { |item| param == item }.length
    else
      to_a.length
    end
  end

  def my_map
    if block_given?
      result = []
      to_a.my_each { |item| result.push(yield item) }
      result
    elsif proc
      to_a.my_each { |item| result.push(proc.call(item)) }
    else
      to_enum(:my_map)
    end
  end

  def my_inject(param = nil)
    new_array = to_a
    if param
      accumulator = param
    else
      accumulator = to_a[0]
      new_array.shift
    end
    new_array.my_each { |item| accumulator = yield(accumulator, item) }
    accumulator
  end
end

def multiply_els(array)
  array.my_inject { |accumulator, item| accumulator * item }
end
