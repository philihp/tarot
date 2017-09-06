class Heuristic

  attr_reader :state

  def initialize(state:)
    @state = state
  end

  def score
    (0..state.players - 1).inject(0) do |accum, p|
      is_current = state.current_player == p ? 1 : -1
      accum + is_current * score_tableau(tableau: state.tableaus[p])
    end
  end

  # TODO: This is naive right now, doesn't even look at chunks of one type
  def score_tableau(tableau:)
    terrains = {
      forest: { size: 0, crowns: 0 },
      lakes: { size: 0, crowns: 0 },
      wheat: { size: 0, crowns: 0 },
      gardens: { size: 0, crowns: 0 },
      mines: { size: 0, crowns: 0 },
      village: { size: 0, crowns: 0 },
    }
    tableau.land.each do |tile|
      score_tile(terrains: terrains, tileside: tile[:l])
      score_tile(terrains: terrains, tileside: tile[:r])
    end
    score = 0
    terrains.each do |k,v|
      score += v[:size] * v[:crowns]
    end
    score
  end

private

  def score_tile(terrains:, tileside:)
    terrain = tileside[:terrain]
    terrains[terrain][:size] += 1
    terrains[terrain][:crowns] += tileside[:crowns]
  end

end
