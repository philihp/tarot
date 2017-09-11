class MTCS::Node

  attr_reader :parent, :move, :wins, :visits, :children, :state, :unexplored_moves

  def initialize(state:, parent:, move:)
    @parent = parent
    @state = state
    @move = move
    @wins = 0.to_f
    @visits = 1
    @children = []
    @unexplored_moves = state.available_moves
    @leaf = state.terminal? || @unexplored_moves.empty?
  end

  SQRT_2 = 1.4142135623730951
  def utc_value
    win_percentage + SQRT_2 * Math.sqrt(Math.log(parent.visits)/@visits)
  end

  def win_percentage
    @wins / @visits
  end

  def root?
    false
  end

  def leaf?
    @leaf
  end

  def utc_select_child
    children.max_by &:utc_value
  end

  def expand
    move = @unexplored_moves.pop
    state = @state.play_move(move: move)
    child = MTCS::Node.new(state: state, move: move, parent: self)
    @children << child
    child
  end

  def simulate
    state = @state.random_walk
    state.winner == @state.current_player
  end

  # TODO simplify
  def backpropagate(win:)
    node = self
    current_player = node.state.current_player
    node.update_stats(win: win) if win
    until node.root? do
      if current_player != node.state.current_player
        win = !win
        current_player = node.state.current_player
      end
      node = node.parent
      node.update_stats(win: win)
    end
  end

  def unexplored_moves?
    !@unexplored_moves.empty?
  end

  def update_stats(win:)
    @visits += 1
    @wins += 1 if win
  end

end
