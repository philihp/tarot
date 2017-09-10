module Tarot
  require "tarot/version"
  require 'tarot/board'
  require 'tarot/state'
  require 'tarot/tableau'
  require 'tarot/heuristic'
  require 'tarot/command_base'
  require 'tarot/command_claim'
  require 'tarot/command_commit'
  require 'tarot/command_place'
end

require 'json'
require 'pp'
require 'ap'

# game = Tarot::State.new
# game = game.play_move(move: game.available_moves[0])
# game = game.play_move(move: game.available_moves[0])
# game = game.play_move(move: game.available_moves[0])
# game = game.play_move(move: game.available_moves[0])
# pp game.to_json
