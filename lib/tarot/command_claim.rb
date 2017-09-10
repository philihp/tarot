class Tarot::CommandClaim < Tarot::CommandBase

  attr_reader :slot

  def initialize(command:)
    super
    raise InvalidMoveException if command.nil?
    tokens = command.split
    raise InvalidMoveException unless tokens.size == 2
    @slot = tokens[1].to_i
  end

  def execute(state:)
    raise InvalidMoveException unless @slot < state.board.old_claims.size
    raise InvalidMoveException unless state.board.new_claims[@slot].nil?
    state = state.dup
    if state.waiting_for == :init_claim
      state.board.new_claims[@slot] = state.current_player
      state.waiting_for = :init_commit
    elsif state.waiting_for == :claim
      claim_index = state.board.find_next_player_index
      state.board.old_claims[claim_index] = nil
      state.tableaus[state.current_player].land << state.board.old_display_tiles[claim_index]
      state.board.old_display_tiles[claim_index] = nil
      state.board.new_claims[@slot] = state.current_player

      # TODO: this should be :place, but doing that later
      state.waiting_for = :commit
    else
      raise InvalidMoveException
    end
    state.history << @command
    state.freeze
  end

end
