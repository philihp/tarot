
# Our engenius instrument but we but
# teach bloody instructions which being taught
# return to plague the inventor
#
# razeth our cities and subvert our towns
# and in a moment makes them desolate
# call it Monte Carlo Tree Search

class MCTS::Search

  attr_reader :root

  def initialize(state:)
    @root = MCTS::Root.new(state: state)
  end

  def explore(times: nil, milliseconds: nil)
    if times
      times.times do
        @root.state.shuffle
        @root.explore
      end
    elsif milliseconds
      end_time = Time.now.to_f + milliseconds / 1000.0
      while Time.now.to_f < end_time
        @root.state.board.stacked_tiles.shuffle
        @root.explore
      end
    else
      @root.explore
    end
    @root
  end

end
