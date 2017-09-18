# Turn on tail recursion optimization
# RubyVM::InstructionSequence.compile_option = {
#   tailcall_optimization: true,
#   trace_instruction: false
# }

module Tarot
  require "tarot/version"
  require 'tarot/board'
  require 'tarot/state'
  require 'tarot/tableau'
  require 'tarot/command_base'
  require 'tarot/command_claim'
  require 'tarot/command_commit'
  require 'tarot/command_place'
end

module MCTS
  require 'mcts/node.rb'
  require 'mcts/root.rb'
  require 'mcts/search.rb'
end

require 'json'
require 'pp'
require 'ap'
require 'ruby-progressbar'

# game = Tarot::State.new
# game = game.play_move(move: game.available_moves[0])
# game = game.play_move(move: game.available_moves[0])
# game = game.play_move(move: game.available_moves[0])
# game = game.play_move(move: game.available_moves[0])
# pp game.to_json

def play_game(bar:nil, time: 1000)
  state = Tarot::State.new
  while !state.terminal?
    move = state.current_player == 0 ? state.suggested_move(milliseconds: time) : state.random_move
    state = state.play_move(move: move)
  end
  bar.increment unless bar.nil?
  state.winner
end
