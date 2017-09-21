class Tarot::Board

  TILES = [
    { id: 1,  l: { terrain: :d, crowns: 0 }, r: { terrain: :d, crowns: 0 } },
    { id: 2,  l: { terrain: :d, crowns: 0 }, r: { terrain: :d, crowns: 0 } },
    { id: 3,  l: { terrain: :f, crowns: 0 }, r: { terrain: :f, crowns: 0 } },
    { id: 4,  l: { terrain: :f, crowns: 0 }, r: { terrain: :f, crowns: 0 } },
    { id: 5,  l: { terrain: :f, crowns: 0 }, r: { terrain: :f, crowns: 0 } },
    { id: 6,  l: { terrain: :f, crowns: 0 }, r: { terrain: :f, crowns: 0 } },
    { id: 7,  l: { terrain: :w, crowns: 0 }, r: { terrain: :w, crowns: 0 } },
    { id: 8,  l: { terrain: :w, crowns: 0 }, r: { terrain: :w, crowns: 0 } },
    { id: 9,  l: { terrain: :w, crowns: 0 }, r: { terrain: :w, crowns: 0 } },
    { id: 10, l: { terrain: :p, crowns: 0 }, r: { terrain: :p, crowns: 0 } },
    { id: 11, l: { terrain: :p, crowns: 0 }, r: { terrain: :p, crowns: 0 } },
    { id: 12, l: { terrain: :s, crowns: 0 }, r: { terrain: :s, crowns: 0 } },
    { id: 13, l: { terrain: :d, crowns: 0 }, r: { terrain: :f, crowns: 0 } },
    { id: 14, l: { terrain: :d, crowns: 0 }, r: { terrain: :w, crowns: 0 } },
    { id: 15, l: { terrain: :d, crowns: 0 }, r: { terrain: :p, crowns: 0 } },
    { id: 16, l: { terrain: :d, crowns: 0 }, r: { terrain: :s, crowns: 0 } },
    { id: 17, l: { terrain: :f, crowns: 0 }, r: { terrain: :w, crowns: 0 } },
    { id: 18, l: { terrain: :f, crowns: 0 }, r: { terrain: :p, crowns: 0 } },
    { id: 19, l: { terrain: :d, crowns: 1 }, r: { terrain: :f, crowns: 0 } },
    { id: 20, l: { terrain: :d, crowns: 1 }, r: { terrain: :w, crowns: 0 } },
    { id: 21, l: { terrain: :d, crowns: 1 }, r: { terrain: :p, crowns: 0 } },
    { id: 22, l: { terrain: :d, crowns: 1 }, r: { terrain: :s, crowns: 0 } },
    { id: 23, l: { terrain: :d, crowns: 1 }, r: { terrain: :g, crowns: 0 } },
    { id: 24, l: { terrain: :f, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 25, l: { terrain: :f, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 26, l: { terrain: :f, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 27, l: { terrain: :f, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 28, l: { terrain: :f, crowns: 1 }, r: { terrain: :w, crowns: 0 } },
    { id: 29, l: { terrain: :f, crowns: 1 }, r: { terrain: :p, crowns: 0 } },
    { id: 30, l: { terrain: :w, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 31, l: { terrain: :w, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 32, l: { terrain: :w, crowns: 1 }, r: { terrain: :f, crowns: 0 } },
    { id: 33, l: { terrain: :w, crowns: 1 }, r: { terrain: :f, crowns: 0 } },
    { id: 34, l: { terrain: :w, crowns: 1 }, r: { terrain: :f, crowns: 0 } },
    { id: 35, l: { terrain: :w, crowns: 1 }, r: { terrain: :f, crowns: 0 } },
    { id: 36, l: { terrain: :d, crowns: 0 }, r: { terrain: :p, crowns: 1 } },
    { id: 37, l: { terrain: :w, crowns: 0 }, r: { terrain: :p, crowns: 1 } },
    { id: 38, l: { terrain: :d, crowns: 0 }, r: { terrain: :s, crowns: 1 } },
    { id: 39, l: { terrain: :p, crowns: 0 }, r: { terrain: :s, crowns: 1 } },
    { id: 40, l: { terrain: :g, crowns: 1 }, r: { terrain: :d, crowns: 0 } },
    { id: 41, l: { terrain: :d, crowns: 0 }, r: { terrain: :p, crowns: 2 } },
    { id: 42, l: { terrain: :w, crowns: 0 }, r: { terrain: :p, crowns: 2 } },
    { id: 43, l: { terrain: :d, crowns: 0 }, r: { terrain: :s, crowns: 2 } },
    { id: 44, l: { terrain: :p, crowns: 0 }, r: { terrain: :s, crowns: 2 } },
    { id: 45, l: { terrain: :g, crowns: 2 }, r: { terrain: :d, crowns: 0 } },
    { id: 46, l: { terrain: :s, crowns: 0 }, r: { terrain: :g, crowns: 2 } },
    { id: 47, l: { terrain: :s, crowns: 0 }, r: { terrain: :g, crowns: 2 } },
    { id: 48, l: { terrain: :d, crowns: 0 }, r: { terrain: :g, crowns: 3 } },
  ]

  attr_accessor :rand
  attr_accessor :old_claims, :new_claims
  attr_accessor :stacked_tiles, :new_display_tiles, :old_display_tiles

  def initialize(rand: Random.new, players:)
    @old_claims = clear_claim_array(players: players)
    @new_claims = clear_claim_array(players: players)
    @new_display_tiles = []
    @old_display_tiles = []
    @rand = rand
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
