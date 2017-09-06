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
game = game.play_move(move: 'claim 1')
game = game.play_move(move: 'commit')
game = game.play_move(move: 'claim 0')
game = game.play_move(move: 'commit')
game = game.play_move(move: 'claim 3')
game = game.play_move(move: 'commit')
game = game.play_move(move: 'claim 2')
game = game.play_move(move: 'commit')
print game.inspect + "\n"
print "#{game.available_moves}\n"
