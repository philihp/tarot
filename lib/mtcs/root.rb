class MTCS::Root < MTCS::Node

  def initialize(state:)
    super(state: state, move: nil, parent: nil)
  end

  def root?
    true
  end

  def best_child
    children.max_by &:win_percentage
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
    win = node.simulate
    # Backpropagation
    node.backpropagate(win: win)
  end

  def update_win(win:)
    @visits += 1
    @wins += 1 unless win
  end

private

  def select
    node = self
    until node.unexplored_moves? || node.leaf? do
      node = node.utc_select_child
    end
    node
  end

end
