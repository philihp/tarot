class MCTS::Node

  attr_reader :parent, :move, :value, :visits, :children, :state, :unexplored_moves

  def initialize(state:, parent:, move:)
    @parent = parent
    @state = state
    @move = move
    @value = 0.to_f
    @visits = 0
    @children = []
    @unexplored_moves = state.available_moves.dup # mutate our own copy during expand, not state's
    @leaf = state.terminal? || @unexplored_moves.empty?
  end

  SQRT_2 = 1.4142135623730951
  def select_value
    mean_value +
      Math.sqrt(
        Math.log(parent.visits + 1) /
        (@visits + Float::EPSILON)
      )
  end

  def mean_value
    @value / (@visits + Float::EPSILON)
  end

  def root?
    false
  end

  def leaf?
    @leaf
  end

  def select_child
    children.max_by &:select_value
  end

  def expand
    move = @unexplored_moves.pop
    state = @state.play_move(move: move)
    child = MCTS::Node.new(state: state, move: move, parent: self)
    @children << child
    child
  end

  def rollout
    state = @state.random_walk
    state.winning_player
  end

  def backpropagate(winner:)
    node = self
    node.update_stats(winner: winner) until (node = node.parent).nil?
    # alternative: tail recursion?
    # update_stats(winner: winner)
    # parent.backpropagate(winner: winner) unless parent.nil?
  end

  def unexplored_moves?
    !@unexplored_moves.empty?
  end

  def update_stats(winner:)
    @visits += 1
    @value += 1 if winner == acting_player
  end

  # The player who took the move to get to this state
  def acting_player
    return parent.state.current_player unless parent.nil?
    -1
  end

end
