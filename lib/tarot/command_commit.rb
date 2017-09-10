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
      if state.board.new_claims.compact.size < state.board.new_claims.size
        state.waiting_for = :init_claim
      else
        if state.board.new_claims.compact.size == state.board.new_claims.size
          start_new_round(state: state)
        end
        state.current_player = state.board.find_next_player
        state.waiting_for = :claim
      end
    elsif state.waiting_for == :commit
      if(state.board.old_claims.compact.size == 0)
        start_new_round(state: state)
      end
      state.current_player = state.board.find_next_player
      state.waiting_for = state.board.new_display_tiles.empty? ? :place : :claim
    else
      raise InvalidMoveException
    end
    state.history << @command
    state.freeze
  end

  def start_new_round(state:)
    state.board.old_claims = state.board.new_claims
    state.board.old_display_tiles = state.board.new_display_tiles
    state.board.new_claims = Array.new(state.board.new_claims.size) { nil }
    state.board.draw_tiles!

    if state.board.stacked_tiles.size == 0
      state.waiting_for = :place
    end
  end

end
