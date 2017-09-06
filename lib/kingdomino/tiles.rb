class Kingdomino::Tiles

  attr_accessor :rand
  attr_accessor :tiles, :display, :claims, :kingdoms

  TILES = [
    { id: 1, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :wheat, crowns: 0 ] },
    { id: 2, l: [ terrain: :wheat, crowns: 1 ], r: [ terrain: :village, crowns: 0 ] },
    { id: 3, l: [ terrain: :forest, crowns: 0 ], r: [ terrain: :forest, crowns: 0 ] },
    { id: 4, l: [ terrain: :lakes, crowns: 0 ], r: [ terrain: :lakes, crowns: 0 ] },
    { id: 5, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :wheat, crowns: 0 ] },
    { id: 6, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :village, crowns: 0 ] },
    { id: 7, l: [ terrain: :forest, crowns: 0 ], r: [ terrain: :forest, crowns: 0 ] },
    { id: 8, l: [ terrain: :lakes, crowns: 0 ], r: [ terrain: :lakes, crowns: 0 ] },
    { id: 9, l: [ terrain: :wheat, crowns: 1 ], r: [ terrain: :forest, crowns: 0 ] },
    { id: 10, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :village, crowns: 1 ] },
    { id: 11, l: [ terrain: :forest, crowns: 0 ], r: [ terrain: :forest, crowns: 0 ] },
    { id: 12, l: [ terrain: :lakes, crowns: 0 ], r: [ terrain: :lakes, crowns: 0 ] },
    { id: 13, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :forest, crowns: 1 ] },
    { id: 14, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :village, crowns: 2 ] },
    { id: 15, l: [ terrain: :forest, crowns: 0 ], r: [ terrain: :forest, crowns: 0 ] },
    { id: 16, l: [ terrain: :lakes, crowns: 0 ], r: [ terrain: :village, crowns: 1 ] },
    { id: 17, l: [ terrain: :wheat, crowns: 0 ], r: [ terrain: :forest, crowns: 1 ] },
    { id: 18, l: [ terrain: :wheat, crowns: 1 ], r: [ terrain: :gardens, crowns: 0 ] },
    { id: 19, l: [ terrain: :forest, crowns: 1 ], r: [ terrain: :lakes, crowns: 0 ] },
    { id: 20, l: [ terrain: :lakes, crowns: 0 ], r: [ terrain: :village, crowns: 2 ] },
  # more tiles go here...
  ]

  def initialize(seed: Random.new_seed)
    @rand = Random.new(seed)
    create_tiles_stack
    create_display
    create_player_kingdoms
  end

  def create_tiles_stack
    @tiles = TILES.shuffle(random: rand).slice(0, 24)
  end

  def create_display
    @display = @tiles.slice!(0, 4)
    @claims = Array.new(4)
  end

  def create_player_kingdoms
    @kingdoms = Array.new(2) { Tarot::Kingdom.new }
  end

  # def to_s
  #   board = "stack:   #{@tiles.map{|t| t[:id]}}\n"\
  #           "display: #{@display.map{|t| t[:id]}}\n"\
  #           "claims:  #{@claims}"
  #   kingdoms = @kingdoms.map.with_index { |k,i| "#{k.to_s}" }
  #   ([board] + kingdoms).join("\n")
  # end

  def to_json
    {
      stack: @tiles.map{|t| t[:id]},
      display: @display.map{|t| t[:id]},
      claims: @claims,
      kingdoms: @kingdoms,
    }
  end
end
