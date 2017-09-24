class Tarot::CommandBase

  attr_reader :command

  def initialize(command:)
    @command = command
  end

  def execute(state:)
    state.history << @command
    state.freeze
  end

  def unexecute(state:)
    raise NotImplementedError
  end

  def to_s
    @command
  end

end
