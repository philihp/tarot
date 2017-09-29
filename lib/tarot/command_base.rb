class Tarot::CommandBase

  attr_reader :command

  def initialize(command:)
    @command = command
  end

  def execute(state:)
    state.history << @command

    # do this after the subclass command mutates the new board state, because
    # available_moves won't be memoizable after freeze.
    state.available_moves

    state.freeze
  end

  def unexecute(state:)
    raise NotImplementedError
  end

  def to_s
    @command
  end

end
