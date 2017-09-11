class Tarot::Board

  # Wheat   +++
  # Village ++++++
  # Forest  +++
  # Lakes
  # Gardens

  TILES = [
    { id: 1, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :wheat, crowns: 0 } },
    { id: 2, l: { terrain: :wheat, crowns: 1 }, r: { terrain: :village, crowns: 0 } },
    { id: 3, l: { terrain: :forest, crowns: 0 }, r: { terrain: :forest, crowns: 0 } },
    { id: 4, l: { terrain: :lakes, crowns: 0 }, r: { terrain: :lakes, crowns: 0 } },
    { id: 5, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :wheat, crowns: 0 } },
    { id: 6, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :village, crowns: 0 } },
    { id: 7, l: { terrain: :forest, crowns: 0 }, r: { terrain: :forest, crowns: 0 } },
    { id: 8, l: { terrain: :lakes, crowns: 0 }, r: { terrain: :lakes, crowns: 0 } },
    { id: 9, l: { terrain: :wheat, crowns: 1 }, r: { terrain: :forest, crowns: 0 } },
    { id: 10, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :village, crowns: 1 } },
    { id: 11, l: { terrain: :forest, crowns: 0 }, r: { terrain: :forest, crowns: 0 } },
    { id: 12, l: { terrain: :lakes, crowns: 0 }, r: { terrain: :lakes, crowns: 0 } },
    { id: 13, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :forest, crowns: 1 } },
    { id: 14, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :village, crowns: 2 } },
    { id: 15, l: { terrain: :forest, crowns: 0 }, r: { terrain: :forest, crowns: 0 } },
    { id: 16, l: { terrain: :lakes, crowns: 0 }, r: { terrain: :village, crowns: 1 } },
    { id: 17, l: { terrain: :wheat, crowns: 0 }, r: { terrain: :forest, crowns: 1 } },
    { id: 18, l: { terrain: :wheat, crowns: 1 }, r: { terrain: :gardens, crowns: 0 } },
    { id: 19, l: { terrain: :forest, crowns: 1 }, r: { terrain: :lakes, crowns: 0 } },
    { id: 20, l: { terrain: :lakes, crowns: 0 }, r: { terrain: :village, crowns: 2 } },
  # more tiles go here...
  ]

  attr_accessor :rand
  attr_accessor :old_claims, :new_claims
  attr_accessor :stacked_tiles, :new_display_tiles, :old_display_tiles

  def initialize(rand:, players:)
    @old_claims = clear_claim_array(players: players)
    @new_claims = clear_claim_array(players: players)
    @new_display_tiles = []
    @old_display_tiles = []
    imagine_future!(with: rand)
    @stacked_tiles = TILES.shuffle(random: rand).slice(0, 24)
    draw_tiles!
  end

  def initialize_copy(source)
    @old_claims = source.old_claims.dup
    @new_claims = source.new_claims.dup
    @rand = source.rand.dup
    @stacked_tiles = source.stacked_tiles.dup
    @new_display_tiles = source.new_display_tiles.dup
    @old_display_tiles = source.old_display_tiles.dup unless source.old_display_tiles.nil?
  end

  def imagine_future!(with: Random.new)
    @rand = with
  end

  def draw_tiles!
    @old_display_tiles = @new_display_tiles
    @new_display_tiles = @stacked_tiles[0..3].sort_by { |tile| tile[:id] }
    @stacked_tiles = @stacked_tiles[4..-1] || []
  end

  def find_next_player
    @old_claims.find { |n| !n.nil? }
  end

  def find_next_player_index
    @old_claims.find_index { |n| !n.nil? }
  end

  def to_json
    {
      old_claims: @old_claims,
      old_display_tiles: @old_display_tiles,
      new_claims: @new_claims,
      new_display_tiles: @new_display_tiles,
    }
  end

private

  def clear_claim_array(players:)
    Array.new(players == 2 ? 4 : players) { nil }
  end

end
