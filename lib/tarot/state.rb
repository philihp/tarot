class Tarot::State

  class InvalidMoveException < Exception
  end

  attr_accessor :rand
  attr_accessor :tableaus, :board, :history
  attr_accessor :current_player, :players

  # Action we are currently waiting for from the active player
  attr_accessor :waiting_for

  def initialize(seed: Random.new_seed, players: 2)
    @rand = Random.new(seed)
    @current_player = 0
    @waiting_for = :init_claim
    @players = players
    @history = []
    create_board
    create_tableaus
  end

  # This is called when something .dup's it, like a command.
  def initialize_copy(source)
    @rand = source.rand.dup
    @board = source.board.dup
    @tableaus = source.tableaus.map(&:dup)
    @history = source.history.dup
  end

  def create_board
    @board = Tarot::Board.new(rand: @rand, players: @players)
  end

  def create_tableaus
    @tableaus = Array.new(@players) { Tarot::Tableau.new(rand: @rand) }
  end

  def play_move(move:, validate: true)
    raise InvalidMoveException unless validate && available_moves.include?(move)

    command = parse_move(string: move)
    # IMPORTANT
    # play_move returns the new state that the command returns, because states should be immutable
    new_state = command.execute(state: self)

    # Undecided if this is a good or a bad thing. If there's only one move,
    # force the player to take it. Seems cool.
    # while new_state.available_moves.size == 1
    while new_state.waiting_for == :commit
      new_state = new_state.play_move(move: new_state.available_moves[0])
    end

    new_state
  end

  def available_moves
    case @waiting_for
    when :init_claim, :claim
      claim_moves
    when :init_commit, :commit
      [ 'commit' ]
    when :place
      place_moves
    else
      []
    end
  end

  def branching_factor
    available_moves.size
  end

  def terminal?
    waiting_for.nil? || available_moves.size == 0
  end

  def claim_moves
    @board.new_claims.each.with_index.inject([]) do |accum,(val,i)|
      accum << "claim #{i}" if val.nil?
      accum
    end
  end

  def place_moves
    [ 'place 0 0 h' ]
  end

  def parse_move(string:)
    case
    when string.start_with?('claim')
      Tarot::CommandClaim.new(command: string)
    when string.start_with?('commit')
      Tarot::CommandCommit.new(command: string)
    when string.start_with?('place')
      Tarot::CommandPlace.new(command: string)
    else
      raise InvalidMoveException, "\"#{string}\""
    end
  end

  def to_json
    {
      board: @board.to_json,
      tableaus: @tableaus.map(&:to_json),
      history: @history,
      options: available_moves,
      _heuristic_score: Heuristic.new(state: self).score
    }
  end
end
