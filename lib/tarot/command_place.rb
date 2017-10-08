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
    raise InvalidMoveException(self.inspect) unless Tarot::CARDINAL_MODIFIER.keys.include?(@orientation)
  end

  def execute(state:)
    prev_state = state
    state = state.dup
    claim_index = state.board.claim_index

    tile = state.board.placing_tile

    # TODO prevent invalid move placement
    state.current_tableau.land[y][x] = tile[:l]
    (offset_x, offset_y) = Tarot::CARDINAL_MODIFIER[orientation]

    binding.pry unless (0..8).cover?(x + offset_x)
    binding.pry unless (0..8).cover?(y + offset_y)

    state.current_tableau.land[y + offset_y][x + offset_x] = tile[:r]

    # binding.pry unless state.current_tableau.legal_size?

    # we lose the ID of the tile here, but it's not really important anymore.
    state.board.placing_tile = nil

    # usually noop, unless on last round when places dont preceed claim
    state.board.old_claims[claim_index] = nil

    state.waiting_for = :commit
    super(state: state)
  end
end
