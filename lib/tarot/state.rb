class Tarot::State < MCTS::State

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
    @available_moves = nil # dont carry this over when a Command .dup's the state
  end

  def shuffle
    board.stacked_tiles.shuffle
  end

  def create_board
    @board = Tarot::Board.new(rand: @rand, players: @players)
  end

  def create_tableaus
    @tableaus = Array.new(@players) { Tarot::Tableau.new }
  end

  def current_tableau
    @tableaus[current_player]
  end

  def play_move(move: , validate: true)
    # you must confine yourself within the modest limits of order
    raise InvalidMoveException unless validate && available_moves.include?(move)

    command = parse_move(string: move)
    # IMPORTANT
    # play_move returns the new state that the command returns, because states should be immutable
    state = command.execute(state: self)

    # Usually this just `commit`s when that's the only thing left to do, however it will also
    # claim the last tile when there's no choice, or trash it or place it in the last spot.
    state = state.play_move(move: state.available_moves[0]) if state.available_moves.size == 1

    state
  end

  def random_walk(depth: 9999)
    state = self.dup
    state.rand = Random.new
    recurse_random_walk(depth: depth)
  end

  def available_moves
    @available_moves ||= begin
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
  end

  def branching_factor
    available_moves.size
  end

  def terminal?
    waiting_for.nil? || available_moves.size == 0
  end

  def winning_player
    return nil unless terminal?
    @tableaus.each_index.max_by { |i| @tableaus[i].score }
  end

  def score_text
    scores = Array.new(players, 0)
    winner = winning_player
    scores[winner] = 1 if winner
    scores
  end

  def claim_moves
    @board.new_claims.each.with_index.inject([]) do |accum,(val,i)|
      accum << "claim #{i}" if val.nil?
      accum
    end
  end

  def place_moves
    moves = []
    # TODO: if get_possible_places were enumerable, then it could do a .map or .inject
    current_tableau.get_possible_places(@board.placing_tile) do |x,y,orientation|
      moves << "place #{x} #{y} #{orientation}"
    end
    moves.empty? ? ['trash'] : moves
  end

  # suit the action to the word, the word to the action
  def parse_move(string:)
    case
    when string.start_with?('claim')
      Tarot::CommandClaim.new(command: string)
    when string.start_with?('commit')
      Tarot::CommandCommit.new(command: string)
    when string.start_with?('place')
      Tarot::CommandPlace.new(command: string)
    when string.start_with?('trash')
      Tarot::CommandTrash.new(command: string)
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
      current_player: @current_player,
    }
  end

  def suggested_move(times: nil, milliseconds: 200)
    search = MCTS::Search.new(state: self)
    search.explore(times: times, milliseconds: milliseconds)
    search.root.best_move
  end

  def recurse_random_walk(depth:)
    return self if terminal? || depth == 0
    play_move(move: random_move).recurse_random_walk(depth: depth - 1)
  end

  def random_move
    available_moves.sample(random: Random.new)
  end
end
