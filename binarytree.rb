#! /usr/bin/ruby

class BinaryTree
  include Enumerable


  def initialize(value=nil)
    @root = nil
    @size = 0
    add(value) if(value)
  end

  def add(value)
    result = nil
    if(!@root)
      @root = BinaryTreeNode.new(value)
      result = value
      @size = 1
    else
      result = add_rec(value,@root)
    end
    return result
  end

  def add_rec(value,node)
    return true if(value == node.value)
	if(value < node.value)
      if(node.left)
        return add_rec(value,node.left)
      else
        node.left = BinaryTreeNode.new(value)
      end
    else
      if(node.right)
        return add_rec(value,node.right)
      else
        node.right = BinaryTreeNode.new(value)
      end
    end
    @size += 1
    return value
  end

  def delete(value)
    delete_rec(value,@root)
  end

  def delete_rec(value,node)
    prev = temp = node
    while(temp && temp.value != value) do
      prev = temp
      if(value < temp.value)
        temp = temp.left
      else
        temp = temp.right
      end
    end
    if !temp
      return nil
    end
    left_node = (prev.left && prev.left.value == temp.value ? true : false)
    if(temp.left && temp.right)
      temp.right.value, temp.value = temp.value, temp.right.value
      return delete_rec(value,temp.right)
    elsif(temp.left)
      if(left_node)
        prev.left = temp.left
      else
        prev.right = temp.left
      end
    elsif(temp.right)
      if(left_node)
        prev.left = temp.right
      else
        prev.right = temp.right
      end
    else
      if(left_node)
        prev.left = nil
      else
        prev.right = nil
      end
    end
    @size -= 1
    return value
  end

  def empty?
    @root == nil
  end

  def include?(value)
    temp = @root
    while(temp && value != temp.value) do
      if(value < temp.value)
        temp = temp.left
      else
        temp = temp.right
      end
    end
    return temp != nil
  end

  def max
    temp = @root
    return nil unless temp
    while(temp.right) do
      temp = temp.right
    end
    return temp.value
  end

  def min
    temp = @root
    return nil unless temp
    while(temp.left) do
      temp = temp.left
    end
    return temp.value
  end

  def height
    return empty? ? 0 : height_rec(@root)
  end

  def height_rec(node)
    return -1 if !node
    left = height_rec(node.left) + 1
    right = height_rec(node.right) + 1
    return left > right ? left : right
  end

  def size
    @size
  end

  def balance
    arr = []
    each {|thing| arr << thing}
    @root = balance_rec(arr,0,arr.length - 1)
  end

  def balance_rec(arr,start,finish)
    if(start > finish)
      return nil
    end
    mid = start + (finish - start)/2
    node = BinaryTreeNode.new(arr[mid])
    node.left = balance_rec(arr,start,mid - 1)
    node.right = balance_rec(arr,mid+1,finish)
    return node
  end

  def each(&block)
    return unless @root
    each_rec(@root.left,block)
    block.call(@root.value)
    each_rec(@root.right,block)
  end
  
  def each_rec(node,block)
    return unless node
    each_rec(node.left,block)
    block.call(node.value)
    each_rec(node.right,block)
  end

end

class BinaryTreeNode
  def initialize(value,left=nil,right=nil)
    @value = value
    @left = left
    @right = right
  end
  attr_accessor :value,:left,:right
end

tree = BinaryTree.new
tree.add(1)
#1.times do |i| tree.add(i) end
#arr = (0..99).to_a
tree.balance
puts tree.to_a
