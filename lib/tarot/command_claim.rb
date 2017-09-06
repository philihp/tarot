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
    if state.waiting_for == :init_claim
      raise InvalidMoveException unless state.board.old_claims[@slot].nil?
      state = state.dup
      state.board.old_claims[@slot] = state.current_player
      state.waiting_for = :init_commit
    elsif state.waiting_for == :claim
      raise NotImplementedError
    else
      raise InvalidMoveException
    end
    state.history << command
    state
  end

end
