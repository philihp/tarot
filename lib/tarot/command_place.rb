class Tarot::CommandPlace < Tarot::CommandBase

  attr_reader :x, :y, :orientation

  def initialize(command:)
    super
    raise InvalidMoveException if command.nil?
    tokens = command.split
    raise InvalidMoveException unless tokens.size == 4
    @x = tokens[1].to_i
    raise InvalidMoveException unless (0..8).cover?(@x)
    @y = tokens[2].to_i
    raise InvalidMoveException unless (0..8).cover?(@y)
    @orientation = tokens[3].to_sym
    raise InvalidMoveException unless [:n, :s, :e, :w].include?(@orientation)
  end

  def execute(state:)
    state = state.dup
    claim_index = state.board.claim_index

    tile = state.board.placing_tile

    # TODO prevent invalid move placement

    state.current_tableau.land[y][x] = tile[:l]
    state.current_tableau.land[y2][x2] = tile[:r]
    # we lose the ID of the tile here, but it's not really important anymore.
    state.board.placing_tile = nil

    # usually noop, unless on last round when places dont preceed claim
    state.board.old_claims[claim_index] = nil

    state.waiting_for = :commit
    super
  end

  def x2
    x + Tarot::CARDINAL_MODIFIER[orientation][0]
  end

  def y2
    y + Tarot::CARDINAL_MODIFIER[orientation][1]
  end
end
