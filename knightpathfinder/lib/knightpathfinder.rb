require_relative '00_tree_node'

class KnightPathFinder
  def self.valid_moves(pos)
    deltas = [[-2, 1], [-2, -1], [1, 2], [-1, 2], [2, 1], [2, -1],
              [1, -2], [-1, -2]]
    valid_moves = []
    deltas.each do |delta|
      row = pos[0] + delta[0]
      col = pos[1] + delta[1]
      on_board = row.between?(0, 7) && col.between?(0, 7)
      valid_moves << [row, col] if on_board
    end
    valid_moves
  end

  def initialize(pos)
    @start_pos = pos
    @visited_pos = [pos]
    @move_tree = []
    build_move_tree
  end

  def find_path(end_pos)
    root_node = @move_tree.first
    end_node = root_node.dfs(end_pos)
    trace_path_back(end_node)
  end

  private

  def new_move_positions(pos)
    valid_moves = KnightPathFinder.valid_moves(pos)
    new_moves = valid_moves.reject { |move| @visited_pos.include?(move) }
    @visited_pos.concat(new_moves)
    new_moves
  end

  def build_move_tree
    root_node = PolyTreeNode.new(@start_pos)
    queue = [root_node]
    @move_tree << root_node
    until queue.empty?
      current_node = queue.shift
      next_moves = new_move_positions(current_node.value)
      next_moves.each do |next_move|
        child_node = PolyTreeNode.new(next_move)
        child_node.parent = current_node
        queue << child_node
        @move_tree << child_node
      end
    end
  end

  def trace_path_back(end_node)
    path = []
    current_node = end_node
    until current_node.nil?
      path.unshift(current_node.value)
      current_node = current_node.parent
    end
    path
  end
end
