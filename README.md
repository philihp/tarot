![Ruby](https://github.com/philihp/tarot/workflows/Ruby/badge.svg)
[![Build Status](https://travis-ci.com/philihp/tarot.svg?branch=master)](https://travis-ci.com/philihp/tarot)

# Tarot

This is an implementation of Kingdominion that I wrote so I could write an AI to play against.

## Using it

Fire up a console

    bin/console
    
Then create an initial gamestate with

    state = Tarot::State.new
    
You can check out the available moves with

    state.available_moves
    
Or try out one of the moves with

    state2 = state.play_move(move: game.available_moves.sample)
    
Each command you run should duplicate the state, muck around with the new one, and then freeze it,
so you can also still keep doing this and try different moves

    state3 = state.play_move(move: game.available_moves.sample)
    state4 = state.play_move(move: game.available_moves.sample)
    state5 = state.play_move(move: game.available_moves.sample) 

## Notes

### State Phases

* `:init_claim`
* `:init_commit`
Repeat until all old_claims are taken
* `:claim`
* `:place`
* `:commit`

### What's the deal with rand?

It's important to explicitly define the random seed, so that the same gamelist can be played through
repeatedly without having to reshuffle the tiles. However, the computer AI can't be allowed ot have
knowledge of the tiles to be drawn, because the computer can't cheat.

One method of tackling this would be to develop a heuristic where the computer looks at the
distribution of tiles left; sort of like card counting in blackjack... however this really bakes in
the strategy that the AI will use and makes it relatively predictable. The advantage here, however,
is that it would allow us to go relatively deep in the game-state-space.

Another strategy would a stochastic monte carlo search the same moves a handful of times. The idea
here is that the move (especially a later-game move) might be good 50% of the time, so let's go for
it, while a bad move might only be good 10% of the time. Usually it's going to pick a decent move.

Another benefit of going about it this way is the computer will never play perfectly. Sometimes it
will make a wildcard play that appears to be bad, even though in its imagined trials, it happened
to luck out.  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Thanks

* https://github.com/PragTob/rubykon - for his ruby implementation of MCTS, of which this was derived. 

* https://github.com/dbravender/tilerealm - for his python implementation of the game. It turns out enumerating possible places to drop a tile is hard.

