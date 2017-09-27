class Tarot::CommandTrash < Tarot::CommandBase

  def initialize(command:)
    super
    raise InvalidMoveException if command.nil?
    raise InvalidMoveException unless command.split.size == 1
  end

  def execute(state:)
    state = state.dup
    claim_index = state.board.claim_index

    state.board.placing_tile = nil
    state.board.old_claims[claim_index] = nil

    state.waiting_for = :commit
    super
  end

end
