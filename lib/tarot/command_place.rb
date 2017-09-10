class Tarot::CommandPlace < Tarot::CommandBase

  attr_reader :x, :y, :orientation

  def initialize(command:)
    super
    raise InvalidMoveException if command.nil?
    tokens = command.split
    raise InvalidMoveException unless tokens.size == 4
    @x = tokens[1].to_i
    raise InvalidMoveException unless (-4..4).cover?(@x)
    @y = tokens[2].to_i
    raise InvalidMoveException unless (-4..4).cover?(@y)
    @orientation = tokens[3].to_sym
    raise InvalidMoveException unless [:h, :v].include?(@orientation)
  end

  def execute(state:)
    state = state.dup
    claim_index = state.board.old_display_tiles.find_index(&:itself)
    state.tableaus[state.current_player].land << state.board.old_display_tiles[claim_index]
    state.board.old_display_tiles[claim_index] = nil

    # only relevant in last round when places dont preceed claim
    state.board.old_claims[claim_index] = nil

    state.history << @command
    state.waiting_for = :commit
    state.freeze
  end

end
