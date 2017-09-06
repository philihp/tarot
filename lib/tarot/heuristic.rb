class Heuristic

  attr_reader :state

  def initialize(state:)
    @state = state
  end

  def score
    (0..state.players - 1).inject(0) do |accum, p|
      is_current = state.current_player == p ? 1 : -1
      accum + is_current * score_tableau(tableau: state.tableaus[p])
    end
  end

  def score_tableau(tableau:)
    # TODO: make this actually mean something
    tableau.land.size
  end

end
