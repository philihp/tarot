class Tarot::CommandCommit < Tarot::CommandBase

  def initialize(command:)
    super
    raise InvalidMoveException if command.nil?
    raise InvalidMoveException unless command.split.size == 1
  end

  def execute(state:)
    state = state.dup
    if state.waiting_for == :init_commit
      state.current_player = (state.current_player + 1) % state.players
      if state.board.old_claims.compact.size < state.board.old_claims.size
        state.waiting_for = :init_claim
      else
        state.board.prepare_for_new_round!
        state.waiting_for = :claim
      end
    elsif state.waiting_for == :commit
      raise NotImplementedError
    else
      raise InvalidMoveException
    end
    state.history << command
    state
  end

end
