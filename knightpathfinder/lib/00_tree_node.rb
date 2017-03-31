class PolyTreeNode
  attr_reader :parent, :children, :value
  def initialize(value = nil)
    @value, @parent, @children = value, nil, []
  end

  def parent=(node)
    @parent.children.delete(self) unless @parent.nil?
    @parent = node
    node.children << self unless node.nil? || node.children.include?(self)
  end

  def add_child(node)
    node.parent = self
  end

  def remove_child(node)
    raise "Node is not a child" unless @children.include?(node)
    node.parent = nil
  end

  def dfs(target_value)
    return self if @value == target_value
    @children.each do |child|
      subtree_search = child.dfs(target_value)
      return subtree_search unless subtree_search.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == target_value
      queue.concat(current_node.children)
    end
  end
end
