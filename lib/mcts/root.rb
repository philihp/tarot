class MCTS::Root < MCTS::Node

  def initialize(state:)
    super(state: state, move: nil, parent: nil)
  end

  def root?
    true
  end

  def best_child
    children.max_by &:visits
  end

  def best_move
    best_child.move
  end

  def explore
    # Selection
    node = select
    # Expansion
    node = node.expand unless node.leaf?
    # Simulation
    winner = node.simulate
    # Backpropagation
    node.backpropagate(winner: winner)
  end

private

  def select
    node = self
    until node.unexplored_moves? || node.leaf? do
      # policy of selection
      node = node.select_child
    end
    node
  end

end
