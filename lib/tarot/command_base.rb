class Tarot::CommandBase

  attr_reader :command

  def initialize(command:)
    @command = command
  end

  def execute(state:)
    raise NotImplementedError
  end

  def unexecute(state:)
    raise NotImplementedError
  end

  def to_s
    @command
  end

end
