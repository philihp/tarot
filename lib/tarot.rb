module Tarot
  require "tarot/version"
  require 'tarot/board'
  require 'tarot/state'
  require 'tarot/tableau'
  require 'tarot/heuristic'
  require 'tarot/command_base'
  require 'tarot/command_claim'
  require 'tarot/command_commit'
end

require 'json'
require 'pp'

game = Tarot::State.new
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
game = game.play_move(move: game.available_moves[0])
pp game.to_json
