# Turn on tail recursion optimization
# RubyVM::InstructionSequence.compile_option = {
#   tailcall_optimization: true,
#   trace_instruction: false
# }

module MCTS
  require 'mcts/node.rb'
  require 'mcts/root.rb'
  require 'mcts/search.rb'
  require 'mcts/state.rb'
end

module Tarot
  MAX_SIZE = 5
  CASTLE_TYPE = :x
  CARDINAL_MODIFIER = {
    w: [-1, 0],
    e: [1, 0],
    n: [0, -1],
    s: [0, 1],
  }
  CARDINAL_INVERSE = {
    w: :e,
    e: :w,
    n: :s,
    s: :n,
  }

  require "tarot/version"
  require 'tarot/board'
  require 'tarot/state'
  require 'tarot/tableau'
  require 'tarot/command_base'
  require 'tarot/command_claim'
  require 'tarot/command_commit'
  require 'tarot/command_place'
end

require 'json'
require 'pp'
require 'ap'
require 'ruby-progressbar'

def play_game(timelimit: 1000)
  state = Tarot::State.new
  while !state.terminal?
    move = state.current_player == 0 ? state.suggested_move(milliseconds: timelimit) : state.random_move
    state = state.play_move(move: move)
  end
  state.winning_player
end

def rollout(times:, timelimit:)
  bar = ProgressBar.create(total: times)
  record = (1..times).map do
    bar.increment
    play_game(timelimit: timelimit) == 0 ? 1 : 0
  end
  wins = record.reduce(:+)
  puts "Win/Loss: #{wins} / #{times} ... #{wins/times.to_f}"
end

def place_state
  state = Tarot::State.new
  state = state.play_move(move: state.available_moves[0])
  state = state.play_move(move: state.available_moves[0])
  state = state.play_move(move: state.available_moves[0])
  state = state.play_move(move: state.available_moves[0])
  state = state.play_move(move: state.available_moves[3])
  state = state.play_move(move: state.available_moves[1])
  state = state.play_move(move: state.available_moves[2])
  state = state.play_move(move: state.available_moves[1])
end
