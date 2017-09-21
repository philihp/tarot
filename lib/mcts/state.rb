class MCTS::State

  attr_writer :rand

  # Given the string `move`, which is an element of `available_moves`, perform that action and
  # return a new MCTS::State object
  def play_move(move:)
    raise NotImplementedException
  end

  # Returns an array of strings which represent moves available to the current_player
  def available_moves
    raise NotImplementedException
  end

  # Returns the current player
  def current_player
    raise NotImplementedException
  end

  def shuffle
    raise NotImplementedException
  end

  def random_walk
    raise NotImplementedException
  end

end
