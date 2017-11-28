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

  require "tarot/version"
  require 'tarot/board'
  require 'tarot/state'
  require 'tarot/tableau'
  require 'tarot/command_base'
  require 'tarot/command_claim'
  require 'tarot/command_commit'
  require 'tarot/command_place'
  require 'tarot/command_trash'
end

require 'json'
require 'pp'
require 'ap'
require 'ruby-progressbar'
require 'time'

def play_game(times:, seed: Random.new_seed)
  state = Tarot::State.new(seed: seed)
  tiles = (state.board.new_display_tiles + state.board.stacked_tiles).map { |t| t[:id] }
  puts "[Seed \"#{seed}\"]"
  puts "[Tiles \"#{tiles.join(' ')}\"]"
  puts "[Generated \"#{Time.now.iso8601}\"]"
  puts
  n = 0
  while !state.terminal?
    n += 1
    move = state.suggested_move(times: times)
    puts "#{n}. #{move}"
    state = state.play_move(move: move)
  end
  state.winning_player
  puts "#{state.score_text}"
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
