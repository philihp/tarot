class MCTS::Search

  attr_reader :root

  def initialize(state:)
    @root = MCTS::Root.new(state: state)
  end

  def explore(times: nil, milliseconds: nil)
    if times
      times.times do
        @root.state.board.stacked_tiles.shuffle
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
